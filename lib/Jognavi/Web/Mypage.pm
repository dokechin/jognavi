package Jognavi::Web::Mypage;
use Mojo::Base 'Mojolicious::Controller';

# This action will render a template
sub index {
  my $self = shift;

  # Render template "mypage/index.html.ep"
  $self->render();
}



1;
