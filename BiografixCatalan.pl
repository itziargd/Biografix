#!/usr/bin/perl 
use strict;
#use warnings;


my  $corpus;
my @Sentences2Treat;
my @titles = '';
my $title = '';
my $sentence = '';




#Create new sentences out of parentehical structures with biographical information. Spanish version.




#open file

open(FITX,$ARGV[0]) or die("Cannot open file $ARGV[0]\n");



# read and clean the corpus
while ($corpus=<FITX>) { 


  $corpus =~ s/–/-/; 
  $corpus =~ s/†//g;
    $corpus =~ s/\*//g; 
    $corpus =~ s/\(n\./\( /g;
  $corpus =~ s/\( n\./\( /g;
    $corpus =~ s/\- m\./- /g;


 if ($corpus=~/\- \)/) {
	     $corpus =~ s/-//g;
	 }


     if ($corpus=~/\ -\)/){
    	$corpus =~ s/ -//g;
     	 }

  
    my @sentences =split('\n', $corpus); 

   
    # look for parenthetical structures
    foreach my $sent(@sentences){  
	
	@titles =split('\t',$sent);
	 $title = $titles[0];
	$title 	=~ s/\s+$//;	
	 $sentence = $titles[1];

	if ($sentence=~/\(/ ){   
	    push(@Sentences2Treat,$sentence);
	     
	    Remove_parenthetical(\@Sentences2Treat,$sentence,$title);
	  
	} #if
} #foreach

} #while




# remove parenthetical strucutres and create the main sentence 

sub Remove_parenthetical{
my @Sentences2Treat = shift;
my $sentence = shift;
my $title = shift;


my @BeforeParenthesis = ''; 
my $subject; 
my @ParentesiAtzekoa = ''; 
my @AfterParenthesis= ''; 
my $treat;
my $parenthetical;
my $pred;
my $MainClause;


@BeforeParenthesis= split('\(',$sentence);
$subject= $BeforeParenthesis[0];


$treat=  $BeforeParenthesis[1];

@AfterParenthesis= split('\)',$treat);
$parenthetical= $AfterParenthesis[0];


$pred= $AfterParenthesis[1];


#Create a sentence for  main clause 
$MainClause = $subject. $pred;



print "$MainClause\n" ;


Treat_the_parenthetical(\@BeforeParenthesis,@AfterParenthesis,$parenthetical)

} # Remove_parenthetical


#look what is in the parenthetical
sub Treat_the_parenthetical{ 

my @BeforeParenthesis = shift ;
my $parenthetical = shift ;
my @AfterParenthesis  = shift ;
my @years = (0 .. 9999);
my $BioData='';

my $parenthetical2; # parenthetical that are not biographical 
my @Dead = '';

my @data = '';
my $BirthData="";
my $DeathData="";



#  look if there is biographical data 

foreach my $year(@years){
    if ($parenthetical =~ $year){
	$BioData = $parenthetical;
	
    }
    elsif  ($parenthetical !~ /\d/){
	 $parenthetical2 = $parenthetical;
    }

}    



if ($BioData =~ /-/){ 
    push(@Dead,$BioData);
}
  else{
      if($BioData ne ""){
           TreatBioData($BioData,$title);
     }
  }





foreach my $hilda(@Dead){

    @data=split(' - ',$hilda);
     @data=split('\d-\d',$hilda); # 1650-1710 BUT  Saint-Germain-en-Laye
 
    
    # to see if it is dead really
    my $size = @data;
    
    if($size < 2){

      
      @data=split(' -',$hilda);
      $size = @data;
       
      if($size < 2){
	  @data=split('- ',$hilda);

      }

 
      
    }
    $BirthData = $data[0];
    $DeathData  = $data[1];
    
}


if ($BirthData ne ""){
       TreatBirth($BirthData,$title);
}
if($DeathData ne "") {
      TreatDeath($DeathData,$title);
}




} # Treat_the_parenthetical


#Reconstruction

# If the person is alive
sub TreatBioData{ 

    my $BioData = shift;
    my @date= '';
    my @place='';
    my $date = '';
    my $place = '';
     my $town = '';
    my $province = '';
    my $state = ''; 
    my $place4 = '';
    my $item22= '';
    my $title = shift;
   

     @date=split(', ', $BioData);
     @place=split(', ',$BioData);


foreach my $item2 (@date){
	if ($item2 =~ /\d/){
	    $date = $item2;
	} 

    }

    my $size=@place;
    
    my $i=0;

    my $nth=0;
   

    while($i<$size){
	$item22=$place[$i];
	
	if($item22 !~ /\d/){
	    
	    if($nth==0){

		$town=$place[$i];
	    }

	    elsif($nth==1){
		$province=$place[$i];

	    }

	    elsif($nth==2){

		$state=$place[$i];
	    }
	    
	    else{

		$place4=$place[$i];

	    }
	    
	    $nth++;
	}

	$i++;

		
    }

# eliminate space at the begining and the end of the string
$date =~ s/^\s+//;
$town=~ s/^\s+//;
$province =~ s/^\s+//;
$state =~  s/^\s+//;
$place4 =~ s/^\s+//;

$date=~ s/\s+$//;
$town=~ s/\s+$//;
$province =~ s/\s+$//;
$state =~ s/\s+$//;	
 $place4 =~ s/\s+$//;


#PRINT NEW SENTENCE
    print "$title naixé "; 
 
    if(($date ne ""  ) && ($date =~/^(\d{1,4})$/)){
	print "en $date";
    }

else {
  print "el $date";

    }
    
     if($town ne ""){
	  print " a "; 
	  print "$town";
     }

    print ".\n";

     if(($town ne "") && ($province ne "") ) {
	
	 print "$town està a $province.\n";
     }

    if(($state ne "") && ($province ne ""))  {
	
	print "$province està a $state.\n";
     }

     if(($state ne "") && ($place4 ne ""))  {
	 
	print "$state està a $place4.\n";
     }

    print "\n";



} # TreatBioData 

# if the person is dead,
sub TreatBirth{ 

    my $BirthData  = shift;
    my @date= '';
    my @place='';
    my $date2 = '';
    my $place2 = '';
    my $town = '';
    my $province = '';
    my $state = '';
    my $place4 = '';
    my $item22= '';
    my $title = shift;

    @date=split(', ', $BirthData);
    @place=split(', ', $BirthData);

    foreach my $item2 (@date){
	if ($item2 =~ /\d/){
	    $date2 = $item2;
	} 

    }

    my $size=@place;
    
    my $i=0;

     my $nth=0;

   
    while($i<$size){
	$item22=$place[$i];
	
	if($item22 !~ /\d/){
	    
	    if($nth==0){

		$town=$place[$i];
	    }

	    elsif($nth==1){
		$province=$place[$i];

	    }

	    elsif($nth==2){

		$state=$place[$i];
	    }
	    
	    else{

		$place4=$place[$i];

	    }
	    
	    $nth++;
	}

	$i++;


    }

#eliminate space at the begining and  the end of the string
$date2 =~ s/^\s+//;
$town=~ s/^\s+//;
$province =~ s/^\s+//;
$state =~  s/^\s+//;
$place4 =~ s/^\s+//;

$date2=~ s/\s+$//;
$town=~ s/\s+$//;
$province =~ s/\s+$//;
$state =~ s/\s+$//;	
 $place4 =~ s/\s+$//;	
 


#PRINT NEW SENTENCE
    print "$title naixé "; 
  

if(($date2 ne ""  ) && ($date2 =~/^(\d{1,4})$/)){
	print "en $date2";
    }

else {
  print "el $date2";
}
    

     if($town ne ""){
	  print " a "; 
	  print "$town";
     }


    print ".\n";

   if(($town ne "") && ($province ne "") ) {
	 print "$town està a $province.\n";
     }

    if(($state ne "") && ($province ne ""))  {
	print "$province està a $state.\n";
     }

     if(($state ne "") && ($place4 ne ""))  {
	print "$state està a $place4.\n";
     }

    #print "\n";

} # TreatBirth


# if the person is dead,
sub TreatDeath{ 

    my $DeathData  = shift;
    my @date= '';
    my @place='';
    my $date3 = '';
    my $place3 = '';
    my $town = '';
    my $province = '';
    my $state = '';
    my $place4 = '';
    my $item22= '';
    my $title = shift;

    if ($DeathData != ""){    # to check that someone alive is not  classified as dead
    
    @date=split(', ', $DeathData);
    @place=split(', ',$DeathData);

      foreach my $item2 (@date){
	if ($item2 =~ /\d/){
	    $date3 = $item2;
	} 

    }

    my $size=@place;
    
    my $i=0;

     my $nth=0;
   

    while($i<$size){
	$item22=$place[$i];
	
	if($item22 !~ /\d/){
	    
	    if($nth==0){

		$town=$place[$i];
	    }

	    elsif($nth==1){
		$province=$place[$i];

	    }

	    elsif($nth==2){

		$state=$place[$i];
	    }
	    
	    else{

		$place4=$place[$i];

	    }
	    
	    $nth++;
	}

	$i++;

    }

#eliminate space at the begining and  the end of the string
$date3 =~ s/^\s+//;
$town=~ s/^\s+//;
$province =~ s/^\s+//;
$state =~  s/^\s+//;
$place4 =~ s/^\s+//;


$date3=~ s/\s+$//;
$town=~ s/\s+$//;
$province =~ s/\s+$//;
$state =~ s/\s+$//;	
 $place4 =~ s/\s+$//;


#PRINT NEW SENTENCE

   print "$title morí ";
  
   
if(($date3 ne ""  ) && ($date3 =~ /^(\d{1,4})$/)){
	print "en $date3";
    }

else {
  print "el $date3";

    }

  
     if($town ne ""){
	  print " a "; 
	  print "$town";
     }


    print ".\n";

   if(($town ne "") && ($province ne "") ) {
	 print "$town està a $province.\n";
     }

    if(($state ne "") && ($province ne ""))  {
	print "$province està a $state.\n";
     }

     if(($state ne "") && ($place4 ne ""))  {
	print "$state està a $place4.\n";
     }

    print "\n";
 } #if not dead 

} #TreatDeath 



close(FITX);
