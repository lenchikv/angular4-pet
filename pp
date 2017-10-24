#!/usr/bin/perl -w

use Encode;
use warnings 'all';
use FindBin qw($Bin);
use lib ('/var/www/dev/cgi');
use lib ($Bin);
#print STDERR $Bin;
use lib ('.');
use locale;
use strict;
use POSIX;
use IO::File;
use DBI;
use LWP::MediaTypes qw(guess_media_type);
use Getopt::Long;
use XML::SimpleObject;
use Data::Dumper;
use Image::Imlib2;
# цпан модуль + сама библиотека imlib2 + imlib2-devel 

use Prescent::Config;
##use Prescent::Misc::Fnd;
use Prescent::DB;
use Prescent::Misc;
##use Prescent::Misc::Web;
use Prescent::Debug;
##use Encode qw(is_utf8);
use strict;
use utf8;

my $XML = "productpricesall.dat";
#my $XMLP = "productprices.dat";
my $VRB = 0;
my $DEB = 0;

my $nullimg = 'null.gif';

my $RCNT = 100;

my $TIMG = "/tmp/tmp.img";
my %EXTS = (
    'image/jpeg' => 'jpg',
	'image/gif'  => 'gif',
	);

#my $qryprod = q{insert into products (findex,ftopic,fappear,ftitle,ftext,fisactive,fispict,fcolor,ftype,flang,fcountry,fisimported) values (?,?,?,?,?,?,?,?,?,?,?,?)};
my $qryprod = q{CALL CreateProdsPricesAll(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)};
#my $qryprod = q{CALL CreateProdsPricesAll(?,?,?,?,?,?,?,?,?,?,?)};
#my $qry2 = q{select csv2pric(?::integer, ?::varchar, ?::float8, ?::float8, ?::smallint, ?::varchar, ?::smallint, ?::smallint, ?::smallint, ?::timestamp, ?::timestamp, ?::timestamp, ?::timestamp, ?::timestamp, ?::timestamp, ?::timestamp, ?::timestamp, ?::timestamp, ?::timestamp, ?::timestamp, ?::timestamp)};
my $qry6 = q{select ftopic, findex, ftitle from products};
my $createprice = q{call CreatePrice()};
#my $qryprice2prod = q{CALL CreatePrice2Prod (?};

#**************************************************************************
sub doit {
    $| = 1;
    
    print "Content-type: text/html\n\n";

    my $dbm = Prescent::DB->create({});
    my $dbh = $dbm->dbh;
	    

	local $/ = undef;

	open(FILE, "< $XML") or die "Не можу відкрити '$XML': $!";
	binmode(FILE);
	my $TXT = <FILE>;
	close(FILE);

	$/ = "\n";

	my $prs = new XML::Parser (ErrorContext => 2, Style => "Tree");
	my $xml = new XML::SimpleObject ($prs->parse($TXT));

#	my ($res) = $dbm->_do_one(q{select csv2ttov4prep()});

	my $cnt = 0;
	my $rss = $xml->child("resultset");
	foreach my $row ($rss->children("row")) {
		my $has = {};
		foreach my $col ($row->children("column")) {
			my $nam = $col->attribute("name");
			my $val = $col->value;

				if ($val) {
					$val =~ s/'/`/g;
				} else {
					$val = '';
				}
				##$val = dectext($val);
					
			$has->{$nam} = $val;
			}

#		my $code = $has->{"Prod_ID"} || '';

		my $code = $has->{"ProductIndex"};
		my $titl = $has->{"ProdPrint_name"} || '';
		my $titlsh = $has->{"ProdShortName"} || '';
		my $rozd = $has->{"Topic_name"} || '';
		my $catg = $has->{"Catg_VariableName"} || '';
		my $lang = $has->{"Lang_VariableName"} || '';
		my $country = $has->{"Country_VariableName"} || '';
		my $appear = $has->{"AppearanceName"} || '';
		my $publisher = $has->{"Publisher"} || '';
		my $publisher_int = $has->{"Publisher_int"} || '';
		my $isAbroad = $has->{"isAbroad"} || '';
		my $ddd = $appear;
		$ddd =~ s/міс/мес/;
		$ddd =~ s/рік/год/;
		$ddd =~ s/тиж/нед/;
#		print $ddd;
		
		my $desc = $has->{"Description"} || '';
		my $term = $has->{"MinTermOfSubscription"} || 1;
		my $price = $has->{"UnitPrice"} || 0.0;
		my $tax = $has->{"TaxUnitPrice"} || 0.0;
		my $color = $has->{"Color_Type"} || 0;
		my $topic = $has->{"Topic_name"} || '';
		
		my $month1 = $has->{"Month1"};
		my $month2 = $has->{"Month2"};
		my $month3 = $has->{"Month3"};
		my $month4 = $has->{"Month4"};
		my $month5 = $has->{"Month5"};
		my $month6 = $has->{"Month6"};
		my $month7 = $has->{"Month7"};
		my $month8 = $has->{"Month8"};		
		my $month9 = $has->{"Month9"};
		my $month10 = $has->{"Month10"};
		my $month11 = $has->{"Month11"};
		my $month12 = $has->{"Month12"};		
		
		my $price1 = $has->{"Price1"};		
		my $price2 = $has->{"Price2"};				
		my $price3 = $has->{"Price3"};				
		my $price4 = $has->{"Price4"};						
		my $price5 = $has->{"Price5"};		
		my $price6 = $has->{"Price6"};		
		my $price7 = $has->{"Price7"};		
		my $price8 = $has->{"Price8"};		
		my $price9 = $has->{"Price9"};		
		my $price10 = $has->{"Price10"};		
		my $price11 = $has->{"Price11"};		
		my $price12 = $has->{"Price12"};				

		my $tax1 = $has->{"Tax1"};						
		my $tax2 = $has->{"Tax2"};								
		my $tax3 = $has->{"Tax3"};								
		my $tax4 = $has->{"Tax4"};						
		my $tax5 = $has->{"Tax5"};						
		my $tax6 = $has->{"Tax6"};						
		my $tax7 = $has->{"Tax7"};						
		my $tax8 = $has->{"Tax8"};						
		my $tax9 = $has->{"Tax9"};								
		my $tax10 = $has->{"Tax10"};						
		my $tax11 = $has->{"Tax11"};						
		my $tax12 = $has->{"Tax12"};						

	        my $fprice_id1 = $has->{"RetailPrice1_ID"};
		my $fprice_id2 = $has->{"RetailPrice2_ID"};
		my $fprice1 = $has->{"PriceHalfYear1"};
		my $fprice2 = $has->{"PriceHalfYear2"};
		my $ftax1 = $has->{"TaxHalfYear1"};
		my $ftax2 = $has->{"TaxHalfYear2"};
		my $fpriceperperiod1 = $has->{"PricePerPeriod1"};
		my $fpriceperperiod2 = $has->{"PricePerPeriod2"};
		my $fminterm1 = $has->{"MinTermOfSubscription1"};
		my $fminterm2 = $has->{"MinTermOfSubscription2"};
		my $startdate1 = $has->{"StartDate1"};						
		my $enddate1 = $has->{"EndDate1"};
		my $startdate2 = $has->{"StartDate2"};
		my $enddate2 = $has->{"EndDate2"};


		
		my $lastdate1 = $has->{"LastSubDate1"};						
		my $lastdate2 = $has->{"LastSubDate2"};								
		my $lastdate3 = $has->{"LastSubDate3"};						
		my $lastdate4 = $has->{"LastSubDate4"};						
		my $lastdate5 = $has->{"LastSubDate5"};						
		my $lastdate6 = $has->{"LastSubDate6"};						
		my $lastdate7 = $has->{"LastSubDate7"};						
		my $lastdate8 = $has->{"LastSubDate8"};						
		my $lastdate9 = $has->{"LastSubDate9"};						
		my $lastdate10 = $has->{"LastSubDate10"};						
		my $lastdate11 = $has->{"LastSubDate11"};						
		my $lastdate12 = $has->{"LastSubDate12"};						

		    
		
		$has->{"Month1"} ||= 0;
		$has->{"Month2"} ||= 0;
		$has->{"Month3"} ||= 0;
		$has->{"Month4"} ||= 0;
		$has->{"Month5"} ||= 0;
		$has->{"Month6"} ||= 0;
		$has->{"Month7"} ||= 0;
		$has->{"Month8"} ||= 0;
		$has->{"Month9"} ||= 0;
		$has->{"Month10"} ||= 0;
		$has->{"Month11"} ||= 0;
		$has->{"Month12"} ||= 0;
		my @mona = (
			$has->{"Month1"},
			$has->{"Month2"},
			$has->{"Month3"},
			$has->{"Month4"},
			$has->{"Month5"},
			$has->{"Month6"},
			$has->{"Month7"},
			$has->{"Month8"},
			$has->{"Month9"},
			$has->{"Month10"},
			$has->{"Month11"},
			$has->{"Month12"}
		);
		my $mask = join('', @mona);
    
		my $year = $has->{"Year"} || 0;
		my $halfyear = $has->{"isHalfYear"} || 0;
	
		my $ispicture = 0;
		if ($has->{"MIMEType"} && ($has->{"MIMEType"} =~ m/^image\//)) {
				$ispicture = 1;
		} else {
				$ispicture = 0;
		}
##		print $code."\n";
##		print $titl."\n";
##		print $country."\n";    
##		print $lang."\n";    
##		print $catg."\n";    
##		print $appear."\n";    
#		print $desc."\n";    
#		print $ispicture."\n";    
#		print $term."\n";   
#		print $price."\n";     
#		print $tax."\n";    
#		print $mask."\n";
#		print $year."\n";
#		print $halfyear."\n";
#		print $color."\n";
#		print $topic."\n";
		

	        print $fprice_id1."\n";
		print $fprice_id2."\n";
		print $fprice1."\n";
		print $fprice2."\n";
		print $ftax1."\n";
		print $ftax2."\n";
		print $fpriceperperiod1."\n";
		print $fpriceperperiod2."\n";
		print $fminterm1."\n";
		print $fminterm2."\n";
		print $price1."\n";
		print $price2."\n";
		print $tax1."\n";		

		
		my $sthprod = $dbh->prepare($qryprod);# готовим запрос
		$sthprod->execute($code,$topic,$ddd, $titl, $titlsh, $desc,$ispicture,$color, $catg, $lang, $country,
		$fprice_id1, $fprice_id2,$fprice1, $fprice2, $ftax1, $ftax2, $fpriceperperiod1, $fpriceperperiod2, $fminterm1, $fminterm2,$year,
		$month1,$month2,$month3,$month4,$month5,$month6,$month7,$month8,$month9,$month10,$month11,$month12,
		$price1, $price2, $price3, $price4, $price5, $price6, $price7, $price8, $price9, $price10, $price11, $price12,
		$tax1, $tax2, $tax3, $tax4, $tax5, $tax6, $tax7, $tax8, $tax9, $tax10, $tax11, $tax12, 
		$lastdate1,$lastdate2,$lastdate3,$lastdate4,$lastdate5,$lastdate6,$lastdate7,$lastdate8,$lastdate9,$lastdate10,$lastdate11,$lastdate12,
		$startdate1, $enddate1, $startdate2, $enddate2, $publisher, $publisher_int, $isAbroad) or $sthprod->errstr; # исполняем запрос
		my $rcprod = $sthprod->finish;    # закрываем

    }


    my $sth = $dbh->prepare($qry6);# готовим запрос
    $sth->execute; # исполняем запрос


    my $cprice = $dbh->prepare($createprice);# готовим запрос
    $cprice->execute; # исполняем запрос



    my $sth = $dbh->prepare($qry6);# готовим запрос
    $sth->execute; # исполняем запрос
	    
    while (my $ref = $sth->fetchrow_arrayref) {
	    print "$$ref[0]\n"; # печатаем результат
    }

#    my $rc = $sth->finish;    # закрываем
#    $rc = $dbh->disconnect;  # соединение}

}

#**************************************************************************
sub prep {
	my $help = 0;
		
        if (!GetOptions(
            'xml|x=s'	=> \$XML,
	    'verbose|v'	=> \$VRB,
	    'help|?'	=> \$help,
            'debug|u'	=> \$DEB,
	) or $help) {
    usage(2);
	  }
}

#**************************************************************************												  
sub usage {
      my ($exit) = @_;
      print STDERR <<EndOfUsage;
Usage: $0 [options]
        -xml      сирцевий текст ($XML)
    	-help     це повідомлення
        -verbose  підвищена балакучість
EndOfUsage
    exit $exit if defined $exit && $exit != 0;
}
												        	        
#**************************************************************************
    &prep;
    &doit;
												        	        
#**************************************************************************
exit(0);



