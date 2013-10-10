package Jognavi::Web::Search;
use Mojo::Base 'Mojolicious::Controller';
use Geo::WKT;
use Geo::Line;
use HTML::FillInForm::Lite;

# This action will render a template
sub index {

  my $self = shift;
  
  my $address = $self->req->param("address");

  my $html = $self->render('/search/index', partial => 1)->to_string;

  $self->render(
    text => HTML::FillInForm::Lite->fill(\$html, {address => $address}),
    format => 'html',
    
    );

}

sub routes {

  my $self = shift;
  
  my $neLat = $self->req->param("neLat");
  my $neLng = $self->req->param("neLng");

  my $nwLat = $self->req->param("nwLat");
  my $nwLng = $self->req->param("nwLng");

  my $seLat = $self->req->param("seLat");
  my $seLng = $self->req->param("seLng");

  my $swLat = $self->req->param("swLat");
  my $swLng = $self->req->param("swLng");

  my $centerLat = ($neLat + $swLat) /2;
  my $centerLng = ($neLng + $swLng) /2;
  
  my $point = "Point(" . $centerLat . " " . $centerLng . ")";

  my $polygon = "Polygon((" .
  $neLat .  " " . $neLng . "," .
  $nwLat .  " " . $nwLng . "," .
  $swLat .  " " . $swLng . "," .
  $seLat .  " " . $seLng . "," .
  $neLat .  " " . $neLng ."))";

  my $ite = $self->db->search_named(q{
  select id,name,distance,route_color,start_address, AsText(g) as linestring,
  case when UserRoute.route_id is not null then '1' else '0' end as mycourse
  from Route left outer join UserRoute on Route.id = UserRoute.route_id and UserRoute.user_id = :id
  where ST_Intersects(GeomFromText(:polygon),g)
  order by ST_Distance(GeomFromText(:point),g)
  limit 0, 20
  },{id => $self->session('id'), polygon => $polygon, point => $point}
  );

  my @routes = ();
  while(my $row = $ite->next){
    my $line = parse_wkt_linestring($row->linestring);
    my %hash = 
    (id => $row->id, 
    name =>  $row->name, 
    distance => $row->distance, 
    route_color=> $row->route_color,
    start_address=>  $row->start_address,
    path=>scalar $line->points());
    if (defined ($self->session("id"))){
        $hash{"mycourse"} = $row->mycourse;
    }
    push (@routes , \%hash);
  }


  $self->render(json=> \@routes);
}

1;
