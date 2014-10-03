use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'CMS' }
BEGIN { use_ok 'CMS::Controller::Admin' }

ok( request('/admin')->is_success, 'Request should succeed' );
done_testing();
