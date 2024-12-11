#!/usr/bin/perl

use DBI;
use CGI;
use strict;
use warnings;

my $q = CGI->new;
my $owner = $q->param('usuario');
my $titulo = $q->param('titulo');

# Database connection
my $user = 'alumno';
my $password = 'pweb1';
my $dsn = "DBI:MariaDB:database=pweb1;host=db";
my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar: " . DBI::errstr);

# Get markdown content
my $sth = $dbh->prepare("SELECT markdown FROM Articles WHERE owner=? AND title=?") 
    or die("Error preparing query: " . $dbh->errstr);
    
$sth->execute($owner, $titulo) or die("Error executing query: " . $sth->errstr);

my @texto;
while (my @row = $sth->fetchrow_array) {
    push (@texto, @row);
}

print $q->header('text/XML');
print "<?xml version='1.0' encoding='utf-8'?>\n";

if (!@texto || !defined $texto[0]) {
    print "<page><error>Article not found</error></page>\n";
    $sth->finish;
    $dbh->disconnect;
    exit;
}

my @lineas = split "\n", $texto[0];
my $textoHTML = "";

for my $linea (@lineas) {
    $textoHTML .= matchLine($linea);
}

print "<page>\n";
print $textoHTML;
print "</page>\n";

$sth->finish;
$dbh->disconnect;

sub matchLine {
    my $linea = $_[0];
    
    return "" if $linea =~ /^\s*$/;  # Skip empty lines
    
    # Process Markdown
    # Headers
    if ($linea =~ /^(\#{6})\s+(.*)/) {
        return "<h6>$2</h6>\n";
    }
    elsif ($linea =~ /^(\#{5})\s+(.*)/) {
        return "<h5>$2</h5>\n";
    }
    elsif ($linea =~ /^(\#{4})\s+(.*)/) {
        return "<h4>$2</h4>\n";
    }
    elsif ($linea =~ /^(\#{3})\s+(.*)/) {
        return "<h3>$2</h3>\n";
    }
    elsif ($linea =~ /^(\#{2})\s+(.*)/) {
        return "<h2>$2</h2>\n";
    }
    elsif ($linea =~ /^(\#{1})\s+(.*)/) {
        return "<h1>$2</h1>\n";
    }
    
    # Format the line
    # Bold + Italic
    while ($linea =~ /(.*)(\*\*\*)(.*)(\*\*\*)(.*)/) {
        $linea = "$1<strong><em>$3</em></strong>$5";
    }
    # Bold
    while ($linea =~ /(.*)(\*\*)(.*)(\*\*)(.*)/) {
        $linea = "$1<strong>$3</strong>$5";
    }
    # Italic
    while ($linea =~ /(.*)(\*)(.*)(\*)(.*)/) {
        $linea = "$1<em>$3</em>$5";
    }
    # Italic with underscore
    while ($linea =~ /(.*)(\_)(.*)(\_)(.*)/){
        $linea = "$1<em>$3</em>$5";
    }
    # Links
    while ($linea =~ /(.*)(\[)(.*)(\])(\()(.*)(\))(.*)/) {
        $linea = "$1<a href='$6'>$3</a>$8";
    }
    # Strikethrough
    while ($linea =~ /(.*)(\~\~)(.*)(\~\~)(.*)/){
        $linea = "$1<del>$3</del>$5";
    }
    # Lists
    if ($linea =~ /^\*\s+(.*)/) {
        return "<li>$1</li>\n";
    }
    # Code blocks
    elsif ($linea =~ /^```(.*)/) {
        return "<pre><code>$1</code></pre>\n";
    }
    
    # Regular paragraph
    return "<p>$linea</p>\n";
}