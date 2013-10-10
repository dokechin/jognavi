package Jognavi::Web::Route;
use Mojo::Base 'Mojolicious::Controller';
use Geo::WKT;
use Geo::Line;
use HTML::FillInForm::Lite;
use POSIX;

# This action will render a template
sub show {

  my $self = shift;

  my $id = $self->param('id');

  my $row = $self->db->single_named('select name,type,distance,route_color,start_address, AsText(g) as linestring from Route Where id=:id', {id => $id});

  my $line = parse_wkt_linestring($row->linestring);
  my $points = $line->points();

  my @array = map { { lat => $_->[0] , lng => $_->[1]} } @$points;

  $self->stash(route_path => \@array);
  $self->stash(km => ceil($row->distance));

  my @records = $self->db->search_named(
    q{select rec.run_time, user.screen_name as user_name, 
    rec.run_at from Record as rec inner join User as user on user.id = rec.user_id 
    Where route_id=:id order by run_time desc limit 0, 20 }, 
    {id => $id});

  $self->stash(record => \@records);

  my $html = $self->render('/route/show', partial => 1)->to_string;

  $self->render(
    text => HTML::FillInForm::Lite->fill(\$html, {course_name => $row->name, course_type => $row->type, distance => $row->distance, start_address => $row->start_address,route_color => $row->route_color}),
    format => 'html',
    );
}



1;
