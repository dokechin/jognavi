package Jognavi::Web::Myequipment;
use Mojo::Base 'Mojolicious::Controller';

sub index {

  my $self = shift;

  my $user_id = $self->session("id");
  my @rows = $self->db->search_by_sql( qq{
      select id,user_id,name,img,url,price,store_url,store_name,0 as distance,bought_at,polish_at 
      from Equipment Where user_id=?
  }, [$user_id]);

  my @json = ();
  foreach my $row (@rows){
      push (@json , {id => $row->id, user_id => $row->user_id, name => $row->name,
      img => $row->img, url => $row->url, price => $row->price + 0, 
      store_url => $row->store_url, store_name => $row->store_name,
      distance => $row->distance + 0,
      bought_at => $row->bought_at, polish_at => $row->polish_at});
  }

  $self->render(
    json => \@json
    );
}

sub create {

  my $self = shift;
  my $json = $self->req->json();

  my $id = $self->session("id");
  my $row = $self->db->insert('Equipment', 
    {user_id => $id, name => $json->{name}, url => $json->{url},price => $json->{price},
    store_url => $json->{store_url}, store_name => $json->{store_name},
     img => $json->{img}, bought_at => $json->{bought_at}, 
     polish_at => $json->{polish_at}, create_at => \"Now()", create_user => $id});

  $self->render(
    json => \$row
    );
}

sub update {

  my $self = shift;
  my $json = $self->req->json();

  my $id = $self->param("id");
  my $row = $self->db->update('Equipment', 
    {name => $json->{name}, url => $json->{url},price => $json->{price},
    store_url => $json->{store_url}, store_name => $json->{store_name},
     img => $json->{img}, bought_at => $json->{bought_at}, 
     polish_at => $json->{polish_at}},
     {id=>$id});

  $self->render(
    json => \$row
    );
}

sub delete {

  my $self = shift;

  my $id = $self->param("id");
  my $row = $self->db->delete('Equipment', {id => $id});

  $self->render(
    json => \$row
    );
}


1;
