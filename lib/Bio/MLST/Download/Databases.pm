package Bio::MLST::Download::Databases;
# ABSTRACT: Represents multiple databases of species


use Moose;
use Bio::MLST::Download::Database;
use Parallel::ForkManager;

has 'databases_attributes' => ( is => 'ro', isa => 'HashRef', required => 1 );
has 'base_directory'       => ( is => 'ro', isa => 'Str',     required => 1 );

has 'parallel_processes'   => ( is => 'ro', isa => 'Int',     default => 4 );

sub update
{
  my($self) = @_;
  my $pm = new Parallel::ForkManager($self->parallel_processes); 
  for my $species (keys %{$self->databases_attributes})
  {
    $pm->start and next; # do the fork
    my $database = Bio::MLST::Download::Database->new(
      species => $species,
      database_attributes => $self->databases_attributes->{$species},
      base_directory      => join('/',($self->base_directory))
    );
    $database->update();
    $pm->finish; # do the exit in the child process
  }
  $pm->wait_all_children;
  1;
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=head1 NAME

Bio::MLST::Download::Databases - Represents multiple databases of species

=head1 VERSION

version 1.133090

=head1 SYNOPSIS

Represents multiple databases of species

   use Bio::MLST::Download::Databases;
   my $databases = Bio::MLST::Download::Databases->new(
     databases_attributes     => \@databases_attributes
     base_directory => '/path/to/dir'
   );
   $databases->update;

=head1 METHODS

=head2 update

Download the database files.

=head1 SEE ALSO

=over 4

=item *

L<Bio::MLST::Download::Downloadable>

=back

=head1 AUTHOR

Andrew J. Page <ap13@sanger.ac.uk>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2012 by Wellcome Trust Sanger Institute.

This is free software, licensed under:

  The GNU General Public License, Version 3, June 2007

=cut
