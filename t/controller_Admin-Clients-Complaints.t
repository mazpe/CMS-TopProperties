use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'CMS' }
BEGIN { use_ok 'CMS::Controller::Admin::Clients::Complaints' }

ok( request('/admin/clients/complaints')->is_success, 'Request should succeed' );
done_testing();
