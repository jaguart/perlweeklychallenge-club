CREATE SCHEMA IF NOT EXISTS pwc154;


CREATE OR REPLACE FUNCTION
pwc154.padovan_plperl(  int )
RETURNS int
AS $CODE$
 return 1 if $_[0] <= 2;
 my ( $a, $b ) = ( $_[ 0 ] - 3, $_[ 0 ] - 2 );
 my $rs = spi_exec_query( "SELECT pwc154.padovan_plperl( $a ) + pwc154.padovan_plperl( $b ) AS p" );
 return $rs->{ rows }[ 0 ]->{ p };

$CODE$
LANGUAGE plperl;

CREATE OR REPLACE FUNCTION
pwc154.padovans_up_to( int )
RETURNS SETOF int
AS $CODE$
 for my $i ( 0 .. $_[ 0 ] ) {
     my $rs = spi_exec_query( "SELECT pwc154.padovan_plperl( $i ) AS p" );
     return_next(  $rs->{ rows }[ 0 ]->{ p } );
 }

 return undef;
$CODE$
LANGUAGE plperl;



SELECT distinct( p.p )
FROM pwc154.padovans_up_to( 20 ) p
ORDER BY 1
LIMIT 10;
