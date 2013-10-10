package Jognavi::Web::Root;
use Mojo::Base 'Mojolicious::Controller';

# This action will render a template
sub index {
  my $self = shift;

  # Render template "example/welcome.html.ep" with message
  $self->render(
    message => 'Welcome to the Mojolicious real-time web framework!');
}

sub login {
  my $self = shift;
  
  if (!defined $self->session("redirect_path")){
      $self->session("redirect_path", "/");
  }

  # Render template "root/login.html.ep"
  $self->render();
}

1;
