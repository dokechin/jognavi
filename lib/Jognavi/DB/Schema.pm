package Jognavi::DB::Schema;
use Teng::Schema::Declare;
use DateTime::Format::MySQL;

    table {
        name 'Route';
        pk id;
        columns qw( id type name route_color description distance g create_user type create_at );

        inflate 'create_at' => sub {
            DateTime::Format::MySQL->parse_datetime(shift);
        };
    #    deflate 'create_at' => sub {
    #        DateTime::Format::MySQL->format_datetime(shift);
    #    };
    };

    table {
        name 'User';
        pk id;
        columns qw( id site user_id screen_name create_at);

        inflate 'create_at' => sub {
            DateTime::Format::MySQL->parse_datetime(shift);
        };

    };

    table {
        name 'UserRoute';
        pk qw(route_id user_id);
        columns qw( route_id user_id create_user create_at);

        inflate 'create_at' => sub {
            DateTime::Format::MySQL->parse_datetime(shift);
        };

    };

    table {
        name 'Equipment';
        pk id;
        columns qw( id user_id bought_at polish_at name url price store_name store_url create_user create_at);
        inflate 'create_at' => sub {
            DateTime::Format::MySQL->parse_datetime(shift);
        };
       inflate 'polish_at' => sub {
            DateTime::Format::MySQL->parse_datetime(shift);
        };

    };

    table {
        name 'Record';
        pk id;
        columns qw( id user_id run_at route_id run_time url create_user create_at);

        inflate 'create_at' => sub {
            DateTime::Format::MySQL->parse_datetime(shift);
        };

    };

    table {
        name 'RecordEquipment';
        pk id;
        columns qw( recourd_id equipment_id create_user create_at);

        inflate 'create_at' => sub {
            DateTime::Format::MySQL->parse_datetime(shift);
        };

    };

1;
