use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'CMS' }
BEGIN { use_ok 'CMS::Controller::Admin::Clients::Accounts' }

ok( request('/admin/clients/accounts')->is_success, 'Request should succeed' );
done_testing();
