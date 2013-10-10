package Jognavi::Web::Record;
use Mojo::Base 'Mojolicious::Controller';

# This action will render a template
sub index {
  my $self = shift;

  $self->render(json => [{title=>"test",start=>"2013-06-13"},{title=>"test2",start=>"2013-06-14"}]);
}



1;