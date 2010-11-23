sub outer {
  my $x = 44;
  our $x = 999;
  sub r(){
    $x = $x + 1;
    print("In subroutine r, x = ",$x,"\n");
  }

  sub q() {
    print("In q \n");
    my $x = 3.14;
    &r;
  }

  sub p() {
    print("In p \n");
    my $x = 55;
    &q;
  }
  &p;
}
print("x = ",$x,"\n");

&outer;
&otherOuter;
sub otherOuter{
  print("x = ", $x, "\n");
}

