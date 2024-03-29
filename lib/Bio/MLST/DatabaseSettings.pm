package Bio::MLST::DatabaseSettings;
# ABSTRACT: Read in an XML file of settings and return a hash with the values.




use Moose;
use XML::LibXML;

has 'filename'          => ( is => 'ro', isa => 'Str', required => 1 );

sub settings
{
  my($self) = @_;
  my %databases_attributes;
  
  my $dom = XML::LibXML->load_xml( location => $self->filename );
  
  for my $species ($dom->findnodes('/data/species')) 
  {
    my $species_name = $self->_clean_string($species->firstChild()->data);

    $databases_attributes{$species_name}{profiles} = $self->_clean_string($species->findnodes('./mlst/database/profiles/url')->[0]->firstChild()->data);
    
    for my $allele ($species->findnodes('./mlst/database/loci/locus'))
    {
      if(! defined ($databases_attributes{$species_name}{alleles}) )
      {
        $databases_attributes{$species_name}{alleles} = [];
      }
      push(@{$databases_attributes{$species_name}{alleles}}, $self->_clean_string($allele->findnodes('./url')->[0]->firstChild()->data));
    }
  }
  return \%databases_attributes;
}


sub _clean_string
{
  my($self, $input_string) = @_;
  chomp($input_string);
  $input_string =~ s![\n\r\t]!!g;
  return $input_string;
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=head1 NAME

Bio::MLST::DatabaseSettings - Read in an XML file of settings and return a hash with the values.

=head1 VERSION

version 1.133090

=head1 SYNOPSIS

Read in an XML file of settings and return a hash with the values.

   use Bio::MLST::DatabaseSettings;
   my $database_settings = Bio::MLST::DatabaseSettings->new(
     filename     => 'filename'
   );
   $database_settings->settings;

=head1 METHODS

=head2 settings

Returns a hash containing the settings for the database, separated by species name, and giving alleles and the profile location.

=head1 AUTHOR

Andrew J. Page <ap13@sanger.ac.uk>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2012 by Wellcome Trust Sanger Institute.

This is free software, licensed under:

  The GNU General Public License, Version 3, June 2007

=cut
