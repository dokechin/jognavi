package Jognavi::Web::Myrecord;
use Mojo::Base 'Mojolicious::Controller';

sub index {

    my $self = shift;

    my $user_id = $self->session("id");
    my @rows    = $self->db->select(
        qq{
      select Record.id,Route.name,Equipment.name as equipment_name,run_at,run_time,
      from Record 
      inner join Route on Record.route_id = Route.id 
      inner join RecordEquipment Record.id = RecordEquipment.record_id
      inner join Equipment RecordEquipment.equipment_id = Equipment.id
      Where Record.user_id=:user_id
      order by Record.id
      }, { user_id => $user_id }
    );

    my @json       = ();
    my $before     = "";
    my @equipments = ();
    foreach $row (@rows) {
        if ( $before eq "" ) {
            $before = $row->id;
            $equipments . push( $row->equipment_name );
        }
        else {
            if ( $before ne $row->id ) {
                push(
                    @json,
                    {
                        id         => $row->id,
                        name       => $row->name,
                        run_at     => $row->run_at,
                        run_time   => $row->run_time,
                        equipments => $equipments
                    }
                );
            }
        }
    }

    if ( $before eq $row->id ) {
        push(
            @json,
            {
                id         => $row->id,
                name       => $row->name,
                run_at     => $row->run_at,
                run_time   => $row->run_time,
                equipments => $equipments
            }
        );
    }

    $self->render( json => \@json );
}

1;
