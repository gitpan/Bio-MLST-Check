package Bio::MLST::Download::Downloadable;
# ABSTRACT: Moose Role to download everything data



use Moose::Role;
use File::Copy;
use File::Basename;
use LWP::Simple;

sub _download_file
{
  my ($self, $filename,$destination_directory) = @_;
  
  # copy if its on the same filesystem
  if(-e $filename)
  {
    copy($filename, $destination_directory);
  }
  else
  {
    getstore($filename, join('/',($destination_directory,$self->_get_filename_from_url($filename))));
  }
  1;
}

sub _get_filename_from_url
{
  my ($self, $filename) = @_;
  if($filename =~ m!/([^/]+)$!)
  {
    return $1;
  }
  
  return int(rand(10000)).".tfa";
}

no Moose;
1;

__END__

=pod

=head1 NAME

Bio::MLST::Download::Downloadable - Moose Role to download everything data

=head1 VERSION

version 1.123540

=head1 SYNOPSIS

Moose Role to download everything data

   with 'Bio::MLST::Download::Downloadable';

=head1 SEE ALSO

=over 4

=item *

L<Bio::MLST::Download::Database>

=item *

L<Bio::MLST::Download::Databases>

=back

=head1 AUTHOR

Andrew J. Page <ap13@sanger.ac.uk>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2012 by Wellcome Trust Sanger Institute.

This is free software, licensed under:

  The GNU General Public License, Version 3, June 2007

=cut
