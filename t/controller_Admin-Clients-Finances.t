use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'CMS' }
BEGIN { use_ok 'CMS::Controller::Admin::Clients::Finances' }

ok( request('/admin/clients/finances')->is_success, 'Request should succeed' );
done_testing();
