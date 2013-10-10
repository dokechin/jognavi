package Jognavi::Web::Views;
use Mojo::Base 'Mojolicious::Controller';
use Geo::WKT;
use Geo::Line;
use HTML::FillInForm::Lite;
use POSIX;

# This action will render a template
sub search {

  my $self = shift;

  my $id = $self->param('id') // 1;

  my $row = $self->db->single_named('select id,name,type,distance,description, route_color,start_address, AsText(g) as linestring from Route Where id=:id', {id => $id});

  my $line = parse_wkt_linestring($row->linestring);
  my $points = $line->points();

  my @array = map { { lat => $_->[0] , lng => $_->[1]} } @$points;

  $self->render(
    json => {id => $row->id, description => $row->description, name =>  $row->name, distance => $row->distance, route_color=> $row->route_color,start_address=>  $row->start_address,path=>scalar $line->points()  }
    );
}



1;
