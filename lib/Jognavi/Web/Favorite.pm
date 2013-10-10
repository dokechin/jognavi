package Jognavi::Web::Favorite;
use Mojo::Base 'Mojolicious::Controller';

sub favorite {

  my $self = shift;

  my $user_id = $self->session("id");
  my $route_id = $self->param("id");
  
  my $row = $self->db->single('UserRoute',
  { user_id => $user_id,
    route_id => $route_id,
  });
  
  if (!defined $row){
    my $route = $self->db->insert('UserRoute',{
      user_id => $user_id,
      route_id => $route_id,
      create_user=> $user_id, 
      create_at => \"Now()"});
  }

  $self->render(json=>{status=> "ok"});
}

sub unfavorite {

  my $self = shift;

  my $user_id = $self->session("id");
  my $route_id = $self->param("id");

  my $row = $self->db->delete('UserRoute',{
    user_id => $user_id,
    route_id => $route_id});

  $self->render(json=>{status=> "ok"});
}


1;