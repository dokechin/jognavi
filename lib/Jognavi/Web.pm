package Jognavi::Web;
use Mojo::Base 'Mojolicious';
use Jognavi::DB;
use Mojolicious::Plugin::Web::Auth;
use Data::Dumper;
# This method will run once at server start
sub startup {
    my $self = shift;

    # Documentation browser under "/perldoc"
    $self->plugin('PODRenderer');

    my $config = $self->plugin( 'Config', { file => 'jognavi.conf' } );

    $self->helper( db => sub { Jognavi::DB->new( $config->{db} ) } );

    #Twitter
    $self->plugin(
        'Web::Auth',
        module      => 'Twitter',
        key         => $config->{twitter_consumer_key},
        secret      => $config->{twitter_consumer_secret},
        on_finished => sub {
            my ( $c, $access_token, $access_secret, $account_info ) = @_;
            $c->session( expiration      => 0 );
            $c->session( 'access_token'  => $access_token );
            $c->session( 'access_secret' => $access_secret );
            $c->session( 'screen_name'   => $account_info->{screen_name} );
            $c->session( 'user_id'       => $account_info->{id} );
            $c->session( 'site'          => "twitter" );
        },
    );

    #Twitter
    $self->plugin(
        'Web::Auth',
        module      => 'Facebook',
        key         => $config->{facebook_app_id},
        secret      => $config->{facebook_app_secret},
        on_finished => sub {
            my ( $c, $access_token, $user_info ) = @_;
            $c->app->log->debug( Dumper($user_info) );

            $c->session( expiration     => 0 );
            $c->session( 'access_token' => $access_token );
            $c->session( 'screen_name'  => $user_info->{name} );
            $c->session( 'user_id'      => $user_info->{id} );
            $c->session( 'site'         => "facebook" );
        },
    );

    $self->hook(before_routes => sub {
        my $c = shift;
        $c->req->headers->if_modified_since(
            'Thu, 01 Jun 1970 00:00:00 GMT'
        );
    });

    #hook
    $self->hook(
        after_dispatch => sub {
            my $c = shift;
            if ( defined $c->session('user_id') ) {
                if ( !defined $c->session('id') ) {
                    my $row = $c->db->single(
                        "User",
                        {
                            site    => $c->session('site'),
                            user_id => $c->session('user_id')
                        }
                    );

                    if ( !defined $row ) {
                        $row = $c->db->insert(
                            "User",
                            {
                                site        => $c->session('site'),
                                screen_name => $c->session('screen_name'),
                                user_id     => $c->session('user_id'),
                                create_at  => \"now()"
                            }
                        );
                    }
                    $c->session( 'id' => $row->id );
                }
            }
        }
    );

    # Router
    my $r = $self->routes;

    my $logged_in = $r->under->to(
        cb => sub {
            my $self = shift;

            if ( $self->session('user_id') ) {

                return 1;
            }
            else {
                $self->session( redirect_path => $self->req->url->path );
                $self->redirect_to('/login');
            }
        }
    );

    # Normal route to controller
    $r->get('/')->to('root#index');

    $logged_in->get('/register')->to('register#index');
    $logged_in->post('/register')->to('register#create');
    $logged_in->get('/register/confirm')->to('register#confirm');
    $logged_in->post('/register/confirm')->to('register#insert');
    $logged_in->get('/register/complete')->to('register#complete');

    $r->get('/route/:id')->to('route#show');
    $r->post('/search')->to('search#index');
    $r->post('/search/routes')->to('search#routes');
    $r->get('/views/:id')->to('views#search');

    $logged_in->get('/myequipment')->to('myequipment#index');
    $logged_in->put('/myequipment/:id')->to('myequipment#update');
    $logged_in->post('/myequipment')->to('myequipment#create');
    $logged_in->delete('/myequipment/:id')->to('myequipment#delete');

    $logged_in->get('/myrecord')->to('myrecord#index');

    $logged_in->post('/favorite/:id')->to('favorite#favorite');
    $logged_in->post('/unfavorite/:id')->to('favorite#unfavorite');

    $r->get('/login')->to("root#login");

    $logged_in->get('/mypage')->to("mypage#index");
#   $r->get('/mypage')->to("mypage#index");

    $r->get('/records')->to("record#index");

    $r->get('/auth/twitter/callback')->to(
        cb => sub {
            my $self     = shift;
            my $redirect = $self->session("redirect_path");
            $self->redirect_to($redirect);
        }
    );

    $r->get('/auth/facebook/callback')->to(
        cb => sub {
            my $self     = shift;
          my $redirect = $self->session("redirect_path");
        }
    );

}

1;
