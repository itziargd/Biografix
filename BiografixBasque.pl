#!/usr/bin/perl 
use strict;
#use warnings;

my  $corpusa;
my @PerpausNagusia = '';
my @Tartekia = '';
my @TratatzekoEsaldiak;
my @tituluak = '';
my $izenburua = '';
my $esaldia = '';
#ANALIZATU gabeko testuatik parentesiak topatu eta datu biografikoekin esaldi berriak sortu. Euskarazko bertsioa.



#fitxategia iriki

open(FITX,$ARGV[0]) or die("Errorea! Ezin $ARGV[0] fitxategia zabaldu\n");



# corpusa/testua irakurri
while ($corpusa=<FITX>) { 

    $corpusa =~ s/–/-/g; #gidoiak denak berdin izateko
    $corpusa =~ s/†//g; #gurutzea kentzeko (eu, de)
    $corpusa =~ s/\*//g; #izartxoa kentzeko (de)  #probatzeko
    $corpusa =~ s/\( n\./\( /g; # nacio kentzeko (es) #probatzeko
    $corpusa =~ s/\- m\./- /g; # murio kentzeko (es) #probatzeko

 

  if ($corpusa=~/\- \)/) {
	     $corpusa =~ s/-//g;
	 }


     if ($corpusa=~/\ -\)/){
    	$corpusa =~ s/ -//g;
     	 }


    
    my @esaldiak =split('\n', $corpusa); 
    foreach my $esaldi(@esaldiak){  # esaldiak banan banan tratatu, begiratu ea tartekirik duten
	
	 @tituluak =split('\t',$esaldi);
	 $izenburua = $tituluak[0];
	 $esaldia = $tituluak[1];

	 $izenburua =~ s/\s+$//;

	if ($esaldia=~/\(/ ){    
	  
	    push(@TratatzekoEsaldiak,$esaldia);
	     
	    Tartekia_Kendu(\@TratatzekoEsaldiak,$esaldia,$izenburua);
	  
	} #if
} #foreach

} #while




# begiratu ea esaldian parentesiak aurkitzen diren: horiek kendu eta perpaus nagusia osatu  (splitting) 

sub Tartekia_Kendu{
my @TratatzekoEsaldiak = shift;
my $esaldia = shift;
my $izenburua = shift;
my @ParentesiAurrekoa = '';
my $subjektua;
my @ParentesiAtzekoa = '';
my $tratatzeko;
my $tartekia;
my $predikatua;
my $PerpausNagusia;





@ParentesiAurrekoa= split('\(',$esaldia);
$subjektua= $ParentesiAurrekoa[0];# baina kontuz, dena ez da gramatikalki subjetuak
$tratatzeko=  $ParentesiAurrekoa[1];

@ParentesiAtzekoa= split('\)',$tratatzeko); 
$tartekia= $ParentesiAtzekoa[0];

$predikatua= $ParentesiAtzekoa[1];

#Pepaus Nagusia OSATU 
$PerpausNagusia = $subjektua. $predikatua;

print "$PerpausNagusia\n" ;


Tartekiak_landu(\@ParentesiAurrekoa,@ParentesiAtzekoa,$tartekia);

} # Tartekia_Kendu


sub Tartekiak_landu{ # parafrastu: remove/adding

my @ParentesiAurrekoa = shift ;
my $tartekia = shift ;
my @ParentesiAtzekoa  = shift ;


my @hilabeteak=  ( 'Urtarril' , 'Otsail' , 'Martxo' , 'Apiril' , 'Maiatz' , 'Ekain' , 'Uztail' , 'Abuztu' , 'Irail' , 'Urri' , 'Azaro' , 'Abendu');
my @egunak = (1 .. 31);
my @urteak = (0 .. 9999);
my $datuBio='';

my $tarteki2; # datu biografikoak ez diren tarteki guztiak

my @Hilda = '';

my @Bizirik = '';

my @datuak = '';

my $jaiotzaData="";

my $hilData="";

my $jatEtimologikoa="";

	

#  datubiografiakoak diren begiratu

foreach my $urte(@urteak){
    if ($tartekia =~ $urte){
	$datuBio = $tartekia;
	
    }
    elsif  ($tartekia !~ /\d/){
	 $tarteki2 = $tartekia;
    }

}    




#datuBIO Heriotza/Jaiotza datuak diren begiratu

if (($datuBio =~ /-/)  || ($datuBio =~ chr(8212))){ #beste marra (luzeagoa) ascii kodea erabiliz
    push(@Hilda,$datuBio);
}
  else{

      if($datuBio ne ""){
          DatuBioTratatu($datuBio,$izenburua);
     }
  }



foreach my $hilda(@Hilda){

    @datuak=split(' - ',$hilda);
     @datuak=split('\d-\d',$hilda); # jaoitza eta heriotza batera dagoenean (letrekin ez, herri izen konposatuak bana daitezke)


    my $size = @datuak;
    
    if($size < 2){

      
      @datuak=split(' -',$hilda);
      $size = @datuak;
       
      if($size < 2){
	  @datuak=split('- ',$hilda);

      }
      
    }
    $jaiotzaData = $datuak[0];
    $hilData  = $datuak[1];
    
}


if ($jaiotzaData ne ""){
    
    JaiotzaTratatu($jaiotzaData,$izenburua);
}
if ($hilData ne "") {    
   HeriotzaTratatu($hilData,$izenburua);
}




} # Tartekiak_landu


#Reconstruction


sub DatuBioTratatu{ #Bizirik daudenentzat

    my $datuBio = shift;
    my @data= '';
    my @lekua= '';
    my $data = '';
    my $lekua = '';
    my $herria = '';
    my $probintzia = '';
    my $estatua = '';
    my $lekua4 = '';
    my $item22= '';
    my $ezezaguna= '';
    my $izenburua = shift;

   

    @data=split(', ', $datuBio);
     @lekua=split(', ',$datuBio);


foreach my $item2 (@data){
	if ($item2 =~ /\d/){
	    $data = $item2;
	} 
       
    }

   

    my $size=@lekua;
    
    my $i=0;
     my $nth=0;


  
while($i<$size){
	$item22=$lekua[$i];
	
	if($item22 !~ /\d/){
	    
	    if($nth==0){

		$herria=$lekua[$i];
	    }

	    elsif($nth==1){
		$probintzia=$lekua[$i];

	    }

	    elsif($nth==2){

		$estatua=$lekua[$i];
	    }
	    
	    else{

		$lekua4=$lekua[$i];

	    }
	    
	    $nth++;
	}

	$i++;

    }


#amaierako zuriuneak kentzeko
$data=~ s/\s+$//;
$herria=~ s/\s+$//;
$probintzia =~ s/\s+$//;
$estatua =~ s/\s+$//;	
 $lekua4 =~ s/\s+$//;


#1915a -> 1915 (an sortu beharrean ean sortzeko)
if(($data ne ""  ) && (($data =~ /5a$/) || ($data =~ /1a$/))) { 
    chop($data); 
    }


#ESALDI BERRIA INPRIMATU  

  
     #print "Bera ";
    print "$izenburua ";

   

    if(($data ne ""  ) && ($data =~ /a$/)) { 
	print "$data". "n ";
    }

  #5 zenbakiarekin amiatzen direnak 
    elsif(($data ne ""  ) && (($data =~ /5$/) || ($data =~ /1$/))) { 
    print "$data". "ean ";
    }

     #inguruan duten esaldientzat 
     elsif(($data ne ""  ) && ($data =~ /an$/)) { 
	print "$data ";
    }
#galdera ikurra duten esaldientzat
    elsif(($data ne ""  ) && ($data =~ /\?$/)) { 
	print "ez dakigu noiz ";
     }

    elsif ($data ne ""  )  {
	print "$data". "an ";
    }


#########LEKUA#############


    if(($herria ne "") && ($herria =~ /[aeiou]$/)) {
        print "$herria". "n ";
    }
    #inguruan duten esaldientzat
    elsif(($herria ne ""  ) && ($herria =~ /an$/)) { 
	print "$herria ";
     }
    
    elsif(($herria ne ""  ) && ($herria =~ /\?$/)) { 
	print "ez dakigu non ";
     }

     else{
	   print "$herria". "en ";
     }
    

    print "jaio zen.\n";

    if(($herria ne "") && ($probintzia ne "") && ($probintzia =~ /[aeiou]$/)) {
	 print "$herria $probintzia". "n dago.\n";
     }
    elsif (($herria ne "") && ($probintzia ne "") && ($probintzia != /[aeiou]$/)) {
	
	print "$herria $probintzia". "en dago.\n";

    }
    

    if(($probintzia ne "") && ($estatua ne "") && ($estatua =~ /[aeiou]$/))  {
	print "$probintzia $estatua". "n dago.\n";
     }
    elsif(($probintzia ne "") && ($estatua ne "")&& ($estatua !~ /[aeiou]$/))  {
	print "$probintzia $estatua". "en dago.\n";
     }



     if(($estatua ne "") && ($lekua4 ne "") && ($lekua4 =~ /[aeiou]$/))  {
	 print "$estatua $lekua4"."n dago.\n";
     }
     elsif(($estatua ne "") && ($lekua4 ne "") && ($lekua4 =~ /[aeiou]$/))  {
	 print "$estatua $lekua4"."en dago.\n";
     }
    


    print "\n";

  
} # DatuBioTratatu


sub JaiotzaTratatu{ #hilda daudenentzat
   
    my $jaiotzaData  = shift;
    my @data= '';
    my @lekua='';
    my $data2 = '';
    my $lekua2 = '';
    my $herria = '';
    my $probintzia = '';
    my $estatua = '';
    my $lekua4 = '';
    my $item22= '';
    my $izenburua = shift;
  
   

    @data=split(', ', $jaiotzaData);
    @lekua=split(', ', $jaiotzaData);

    foreach my $item2 (@data){
	if ($item2 =~ /\d/){
	    $data2 = $item2;
	} 

    }

    my $size=@lekua;
    
    my $i=0;
     my $nth=0;

   
    while($i<$size){
	$item22=$lekua[$i];
	
	if($item22 !~ /\d/){
	    
	    if($nth==0){

		$herria=$lekua[$i];
	    }

	    elsif($nth==1){
		$probintzia=$lekua[$i];

	    }

	    elsif($nth==2){

		$estatua=$lekua[$i];
	    }
	    
	    else{

		$lekua4=$lekua[$i];

	    }
	    
	    $nth++;
	}

	$i++;


    }	

#amaierako zuriuneak kentzeko
$data2=~ s/\s+$//;
$herria=~ s/\s+$//;
$probintzia =~ s/\s+$//;
$estatua =~ s/\s+$//;	
 $lekua4 =~ s/\s+$//;	
 
#1915a -> 1915 (an sortu beharrean ean sortzeko)
if(($data2 ne ""  ) && (($data2 =~ /5a$/) || ($data2 =~ /1a$/))) { 
    chop($data2); 
    }

#ESALDI BERRIA INPRIMATU

     #print "Bera ";
     print "$izenburua ";

    if(($data2 ne ""  ) && ($data2 =~ /a$/)) { 
    print "$data2". "n ";
    }

     #5 zenbakiarekin amiatzen direnak 
    elsif(($data2 ne ""  ) && ($data2 =~ /5$/) || ($data2 =~ /1$/)) { 
    print "$data2". "ean ";
    }
 #inguruan duten esaldientzat #probatzeko
     elsif(($data2 ne ""  ) && ($data2 =~ /ruan$/)) { 
 	print "$data2 ";
   }

 #galdera ikurra duten esaldientzat 
     elsif(($data2 ne ""  ) && ($data2 =~ /\?$/)) { 
 	print "ez dakigu noiz ";
      }
    elsif ($data2 ne ""  )  {
	#print "$data2-n ";
	print "$data2". "an ";
    }
    
#########LEKUA#############


    if(($herria ne "") && ($herria =~ /[aeiou]$/)) {
        print "$herria". "n ";
     }
      #inguruan duten esaldientzat
     elsif(($herria ne ""  ) && ($herria =~ /an$/)) { 
      	print "$herria ";
      }

    elsif(($herria ne ""  ) && ($herria =~ /\?$/)) { 
	print "ez dakigu non ";
     }

     elsif($herria ne ""  )  {
	    print "$herria". "en ";
     }
 
    
    print "jaio zen.\n";


    if(($herria ne "") && ($probintzia ne "") && ($probintzia =~ /[aeiou]$/)) {
	 print "$herria $probintzia". "n dago.\n";
     }
    elsif (($herria ne "") && ($probintzia ne "") && ($probintzia != /[aeiou]$/)) {
	print "$herria $probintzia". "en dago.\n";

    }
    

    if(($probintzia ne "") && ($estatua ne "") && ($estatua =~ /[aeiou]$/))  {
	print "$probintzia $estatua". "n dago.\n";
     }
    elsif(($probintzia ne "") && ($estatua ne "")&& ($estatua !~ /[aeiou]$/))  {
	print "$probintzia $estatua". "en dago.\n";
     }



     if(($estatua ne "") && ($lekua4 ne "") && ($lekua4 =~ /[aeiou]$/))  {
	 print "$estatua $lekua4"."n dago.\n";
     }
     elsif(($estatua ne "") && ($lekua4 ne "") && ($lekua4 =~ /[aeiou]$/))  {
	 print "$estatua $lekua4"."en dago.\n";
     }


    # print "\n"; #bizitza eta heriotzaren arteko lerro saltoa kendu

} # JaiotzaTratatu



sub HeriotzaTratatu{ #hilda daudenentzat
  
    my $hilData  = shift;
    my @data= '';
    my @lekua='';
    my $data3 = '';
    my $herria = '';
    my $probintzia = '';
    my $estatua = '';
    my $lekua4 = '';
    my $item22= '';
    my $izenburua = shift;
 

   

  	@data=split(', ', $hilData);
	@lekua=split(', ',$hilData);

    

 foreach my $item2 (@data){
	if ($item2 =~ /\d/){
	    $data3 = $item2;
	} 

    }

    my $size=@lekua;
    my $i=0;
     my $nth=0;

     while($i<$size){
	$item22=$lekua[$i];
	
	if($item22 !~ /\d/){
	    
	    if($nth==0){

		$herria=$lekua[$i];
	    }

	    elsif($nth==1){
		$probintzia=$lekua[$i];

	    }

	    elsif($nth==2){

		$estatua=$lekua[$i];
	    }
	    
	    else{

		$lekua4=$lekua[$i];

	    }
	    
	    $nth++;
	}

	$i++;


    }
#amaierako zuriuneak kentzeko
$data3=~ s/\s+$//;
$herria=~ s/\s+$//;
$probintzia =~ s/\s+$//;
$estatua =~ s/\s+$//;	
 $lekua4 =~ s/\s+$//;

#1915a -> 1915 (an sortu beharrean ean sortzeko)
    if(($data3 ne ""  ) && (($data3 =~ /5a$/) || ($data3 =~ /1a$/))) { 
    chop($data3); 
    }  

#ESALDI BERRIA INPRIMATU

    # print "Bera ";
    print "$izenburua ";

    if(($data3 ne ""  ) && ($data3 =~ /a$/)) { 
    print "$data3". "n ";
    }
    

  #5 zenbakiarekin amiatzen direnak 
    elsif(($data3 ne ""  ) && ($data3 =~ /5$/) || ($data3 =~ /1$/)) { 
    print "$data3". "ean ";
    }
 #inguruan duten esaldientzat
    elsif(($data3 ne ""  ) && ($data3 =~ /an$/)) { 
 	print "$data3 ";
    }
 #galdera ikurra duten esaldientzat 
 elsif(($data3 ne ""  ) && ($data3 =~ /\?$/)) { 
	print "ez dakigu noiz ";
     }

 elsif ($data3 ne ""  )  {
	print "$data3". "an ";
    }

    
#########LEKUA#############



    if(($herria ne "") && ($herria =~ /[aeiou]$/)) {
        print "$herria". "n ";
     }
 #inguruan duten esaldientzat
    elsif(($herria ne ""  ) && ($herria =~ /an$/)) { 
	print "$herria ";
     }

    elsif(($herria ne ""  ) && ($herria =~ /\?$/)) { 
	print "ez dakigu non ";
     }
     elsif($herria ne ""  )  {
	 print "$herria". "en ";
     }
    
    print "hil zen.\n";

   if(($herria ne "") && ($probintzia ne "") && ($probintzia =~ /[aeiou]$/)) {
	 print "$herria $probintzia". "n dago.\n";
     }
    elsif (($herria ne "") && ($probintzia ne "") && ($probintzia != /[aeiou]$/)) {
	print "$herria $probintzia". "en dago.\n";

    }
    

    if(($probintzia ne "") && ($estatua ne "") && ($estatua =~ /[aeiou]$/))  {
	print "$probintzia $estatua". "n dago.\n";
     }
    elsif(($probintzia ne "") && ($estatua ne "")&& ($estatua !~ /[aeiou]$/))  {
	print "$probintzia $estatua". "en dago.\n";
     }



     if(($estatua ne "") && ($lekua4 ne "") && ($lekua4 =~ /[aeiou]$/))  {
	 print "$estatua $lekua4"."n dago.\n";
     }
     elsif(($estatua ne "") && ($lekua4 ne "") && ($lekua4 =~ /[aeiou]$/))  {
	 print "$estatua $lekua4"."en dago.\n";
     }

     print "\n";


} # HeriotzaTratatu





# Fitxategi berri batean idatzi
# fitxategiak itxi
close(FITX);
