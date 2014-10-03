use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'CMS' }
BEGIN { use_ok 'CMS::Controller::Login' }

ok( request('/login')->is_success, 'Request should succeed' );
done_testing();
