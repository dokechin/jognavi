package Jognavi::Web::Register;
use Mojo::Base 'Mojolicious::Controller';
use JSON::XS;
use URI::Escape;
use Plack::Session;
use HTML::FillInForm::Lite;
use Data::Dumper;
use POSIX;
use Convert::Color;

# This action will render a template
sub index {
  my $self = shift;
  
  $self->stash(course_type => $self->flash("course_type"));
  if ($self->flash('route_path')){
      my $data = $self->flash("route_path");
      $self->app->log->debug($data->{path});
      $self->stash( route_path => $data->{path});
  }
  else{
      $self->stash( route_path => []);
  }
  # Render template "register/index.html.ep" with message
  $self->render();
}

# This action will render a template
sub create {

  my $self = shift;

  my $name = $self->req->param("course_name");
  my $type = $self->req->param("course_type");
  my $start_address = $self->req->param("start_address");
  my $description = $self->req->param("description");

  my $data = $self->req->param("data");
  $data =~ tr/+/ /;
  $data = uri_unescape( $data);

  my $hash = decode_json $data;
  my $route_path = $hash->{"path"};
  my $distance = $hash->{"distance"};


 my $color = Convert::Color->new( 'hsv:' . rand(360) . ',0.70,1.00' );
 my $route_color = '#' . $color->as_rgb8->hex;

  $self->flash(course_name => $name);
  $self->flash(course_type => $type);
  $self->flash(route_path => $route_path);
  $self->flash(distance => $distance);
  $self->flash(start_address => $start_address);
  $self->flash(route_color => $route_color);
  $self->flash(description => $description);

  $self->res->code(303);

  $self->redirect_to("/register/confirm");

}

sub confirm {

  my $self = shift;

  my $course_name = $self->flash("course_name");
  my $course_type = $self->flash("course_type");
  my $route_path = $self->flash("route_path");
  my $distance = $self->flash("distance");
  my $start_address = $self->flash("start_address");
  my $description = $self->flash("description");
  my $route_color = $self->flash("route_color");

  $self->stash(km => ceil($distance));

  if ( $route_path){
    $self->stash('route_path' =>  $route_path);
  }
  else{
    $self->stash('route_path' =>  {});
  }

  my $html = $self->render('/register/confirm', partial => 1)->to_string;

  $self->render(
    text => HTML::FillInForm::Lite->fill(\$html, {course_name => $course_name, course_type => $course_type, description => $description, distance => $distance, start_address => $start_address,route_color => $route_color}),
    format => 'html',
    
    );

}

# This action will render a template
sub insert {
  my $self = shift;

  my $course_name = $self->req->param("course_name");
  my $course_type = $self->req->param("course_type");
  my $distance = $self->req->param("distance");
  my $route_path = $self->req->param("route_path");
  my $cancel = $self->req->param("cancel_button");
  my $start_address = $self->req->param("start_address");
  my $route_color = $self->req->param("route_color");
  my $description = $self->req->param("description");


  $route_path =~ tr/+/ /;
  $route_path = uri_unescape( $route_path);

  my $hash = decode_json $route_path;

  if ($cancel){

    $self->flash(route_path => $hash);
    $self->flash(course_name => $course_name);
    $self->flash(course_type => $course_type);
    $self->flash(description => $description);
    $self->flash(start_address => $start_address);

    $self->res->code(303);

    $self->redirect_to('/register');

    return;

  }

  my $linestring = "LINESTRING (";

  $self->app->log->debug($linestring);

  my $array_ref = $hash->{"path"};
  my $count = scalar @{$array_ref};
  $self->app->log->debug($count);
  foreach (0 .. $count-1) {
    if ($_ > 0){
      $linestring = $linestring . ",";
    }
    $linestring = $linestring . $array_ref->[$_]->{ lat } . " " .  $array_ref->[$_]->{ lng };
  }
  $linestring = $linestring . ")";

  my $route = $self->db->insert('Route',
    {g=> \["GeomFromText(?)", $linestring],
    type => $course_type,
    distance => $distance,
    start_address => $start_address,
    route_color => $route_color,
    description => $description,
    name => $course_name, 
    create_user=> $self->session("id"), 
    create_at => \"Now()"});

  my $id = $route->id;

  $self->res->code(303);

  $self->redirect_to("/register/complete");
}


1;
