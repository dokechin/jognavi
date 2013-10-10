package Jognavi::Web::MyEquipment;
use Mojo::Base 'Mojolicious::Controller';

sub index {

  my $self = shift;

  my $id = $self->session("id");
  my @rows = $self->db->select('select name,img,url,price,store_url,store_name,distance,bought_at,polish_at from Equipment Where id=:id', {user_id => $id});

  $self->render(
    json => \@rows
    );
}

sub create {

  my $self = shift;
  my $json = $self->req->json();

  my $id = $self->session("id");
  my $row = $self->db->insert('Equipment', 
    {user_id => $id, name => $json->{name}, url => $json->{url},price => $json->price,
    store_url => $json->store_url, store_name => $json->store_name,
     img => $json->{img}, bought_at => $json->{bought_at}, 
     diposit_at => $json->{diposit_at}, create_at => \"Now()", create_user => $id});

  $self->render(
    json => \$row
    );
}

sub delete {

  my $self = shift;

  my $id = $self->session("id");
  my $route_id = $self->param("id");
  my $row = $self->db->delete('Equipment', {id => $route_id, user_id => $id});

  $self->render(
    json => \$row
    );
}


1;
