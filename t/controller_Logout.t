use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'CMS' }
BEGIN { use_ok 'CMS::Controller::Logout' }

ok( request('/logout')->is_success, 'Request should succeed' );
done_testing();
