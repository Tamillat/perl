#!./perl

BEGIN {
    chdir 't' if -d 't';
    @INC = '../lib';
}

use Math::BigFloat;

$test = 0;
$| = 1;
print "1..406\n";
while (<DATA>) {
       chop;
       if (s/^&//) {
               $f = $_;
	} elsif (/^\$.*/) {
		eval "$_;";
       } else {
               ++$test;
	       if (m|^(.*?):(/.+)$|) {
	           $ans = $2;
                   @args = split(/:/,$1,99);
	       }
	       else {
                   @args = split(/:/,$_,99);
                   $ans = pop(@args);
	       }
               $try = "\$x = new Math::BigFloat \"$args[0]\";";
               if ($f eq "fnorm"){
                   $try .= "\$x+0;";
               } elsif ($f eq "fneg") {
                   $try .= "-\$x;";
               } elsif ($f eq "fabs") {
                   $try .= "abs \$x;";
               } elsif ($f eq "fint") {
                   $try .= "int \$x;";
               } elsif ($f eq "fround") {
                   $try .= "0+\$x->fround($args[1]);";
               } elsif ($f eq "ffround") {
                   $try .= "0+\$x->ffround($args[1]);";
               } elsif ($f eq "fsqrt") {
                   $try .= "0+\$x->fsqrt;";
               } else {
                   $try .= "\$y = new Math::BigFloat \"$args[1]\";";
                   if ($f eq "fcmp") {
                       $try .= "\$x <=> \$y;";
                   } elsif ($f eq "fadd") {
                       $try .= "\$x + \$y;";
                   } elsif ($f eq "fsub") {
                       $try .= "\$x - \$y;";
                   } elsif ($f eq "fmul") {
                       $try .= "\$x * \$y;";
                   } elsif ($f eq "fdiv") {
                       $try .= "\$x / \$y;";
                   } else { warn "Unknown op"; }
               }
               #print ">>>",$try,"<<<\n";
               $ans1 = eval $try;
	       if ($ans =~ m|^/(.*)$|) {
	           my $pat = $1;
		   if ($ans1 =~ /$pat/) {
                       print "ok $test\n";
		   }
		   else {
                       print "not ok $test\n";
                       print "# '$try' expected: /$pat/ got: '$ans1'\n";
		   }
	       }
               elsif ("$ans1" eq $ans) { #bug!
                       print "ok $test\n";
               } else {
                       print "not ok $test\n";
                       print "# '$try' expected: '$ans' got: '$ans1'\n";
               }
       }
} 

{
  use Math::BigFloat ':constant';

  $test++;
  # print "# " . 2. * '1427247692705959881058285969449495136382746624' . "\n";
  print "not "
    unless 2. * '1427247692705959881058285969449495136382746624'
	    == "2854495385411919762116571938898990272765493248.";
  print "ok $test\n";
  $test++;
  @a = ();
  for ($i = 1.; $i < 10; $i++) {
    push @a, $i;
  }
  print "not " unless "@a" eq "1. 2. 3. 4. 5. 6. 7. 8. 9.";
  print "ok $test\n";
}

__END__
&fnorm
abc:NaN.
   1 a:NaN.
1bcd2:NaN.
11111b:NaN.
+1z:NaN.
-1z:NaN.
0:0.
+0:0.
+00:0.
+0 0 0:0.
000000  0000000   00000:0.
-0:0.
-0000:0.
+1:1.
+01:1.
+001:1.
+00000100000:100000.
123456789:123456789.
-1:-1.
-01:-1.
-001:-1.
-123456789:-123456789.
-00000100000:-100000.
123.456a:NaN.
123.456:123.456
0.01:.01
.002:.002
-0.0003:-.0003
-.0000000004:-.0000000004
123456E2:12345600.
123456E-2:1234.56
-123456E2:-12345600.
-123456E-2:-1234.56
1e1:10.
2e-11:.00000000002
-3e111:-3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000.
-4e-1111:-.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004
&fneg
abd:NaN.
+0:0.
+1:-1.
-1:1.
+123456789:-123456789.
-123456789:123456789.
+123.456789:-123.456789
-123456.789:123456.789
&fabs
abc:NaN.
+0:0.
+1:1.
-1:1.
+123456789:123456789.
-123456789:123456789.
+123.456789:123.456789
-123456.789:123456.789
&fround
$Math::BigFloat::rnd_mode = 'trunc'
+10123456789:5:10123000000
-10123456789:5:-10123000000
+10123456789:9:10123456700
-10123456789:9:-10123456700
+101234500:6:101234000
-101234500:6:-101234000
$Math::BigFloat::rnd_mode = 'zero'
+20123456789:5:20123000000
-20123456789:5:-20123000000
+20123456789:9:20123456800
-20123456789:9:-20123456800
+201234500:6:201234000
-201234500:6:-201234000
$Math::BigFloat::rnd_mode = '+inf'
+30123456789:5:30123000000
-30123456789:5:-30123000000
+30123456789:9:30123456800
-30123456789:9:-30123456800
+301234500:6:301235000
-301234500:6:-301234000
$Math::BigFloat::rnd_mode = '-inf'
+40123456789:5:40123000000
-40123456789:5:-40123000000
+40123456789:9:40123456800
-40123456789:9:-40123456800
+401234500:6:401234000
-401234500:6:-401235000
$Math::BigFloat::rnd_mode = 'odd'
+50123456789:5:50123000000
-50123456789:5:-50123000000
+50123456789:9:50123456800
-50123456789:9:-50123456800
+501234500:6:501234000
-501234500:6:-501234000
$Math::BigFloat::rnd_mode = 'even'
+60123456789:5:60123000000
-60123456789:5:-60123000000
+60123456789:9:60123456800
-60123456789:9:-60123456800
+601234500:6:601235000
-601234500:6:-601235000
&ffround
$Math::BigFloat::rnd_mode = 'trunc'
+1.23:-1:1.2
-1.23:-1:-1.2
+1.27:-1:1.2
-1.27:-1:-1.2
+1.25:-1:1.2
-1.25:-1:-1.2
+1.35:-1:1.3
-1.35:-1:-1.3
-0.006:-1:0
-0.006:-2:0
-0.0065:-3:/-0\.006|-6e-03
-0.0065:-4:/-0\.006(?:5|49{5}\d+)|-6\.5e-03
-0.0065:-5:/-0\.006(?:5|49{5}\d+)|-6\.5e-03
$Math::BigFloat::rnd_mode = 'zero'
+2.23:-1:/2.2(?:0{5}\d+)?
-2.23:-1:/-2.2(?:0{5}\d+)?
+2.27:-1:/2.(?:3|29{5}\d+)
-2.27:-1:/-2.(?:3|29{5}\d+)
+2.25:-1:/2.2(?:0{5}\d+)?
-2.25:-1:/-2.2(?:0{5}\d+)?
+2.35:-1:/2.(?:3|29{5}\d+)
-2.35:-1:/-2.(?:3|29{5}\d+)
-0.0065:-1:0
-0.0065:-2:/-0\.01|-1e-02
-0.0065:-3:/-0\.006|-6e-03
-0.0065:-4:/-0\.006(?:5|49{5}\d+)|-6\.5e-03
-0.0065:-5:/-0\.006(?:5|49{5}\d+)|-6\.5e-03
$Math::BigFloat::rnd_mode = '+inf'
+3.23:-1:/3.2(?:0{5}\d+)?
-3.23:-1:/-3.2(?:0{5}\d+)?
+3.27:-1:/3.(?:3|29{5}\d+)
-3.27:-1:/-3.(?:3|29{5}\d+)
+3.25:-1:/3.(?:3|29{5}\d+)
-3.25:-1:/-3.2(?:0{5}\d+)?
+3.35:-1:/3.(?:4|39{5}\d+)
-3.35:-1:/-3.(?:3|29{5}\d+)
-0.0065:-1:0
-0.0065:-2:/-0\.01|-1e-02
-0.0065:-3:/-0\.006|-6e-03
-0.0065:-4:/-0\.006(?:5|49{5}\d+)|-6\.5e-03
-0.0065:-5:/-0\.006(?:5|49{5}\d+)|-6\.5e-03
$Math::BigFloat::rnd_mode = '-inf'
+4.23:-1:/4.2(?:0{5}\d+)?
-4.23:-1:/-4.2(?:0{5}\d+)?
+4.27:-1:/4.(?:3|29{5}\d+)
-4.27:-1:/-4.(?:3|29{5}\d+)
+4.25:-1:/4.2(?:0{5}\d+)?
-4.25:-1:/-4.(?:3|29{5}\d+)
+4.35:-1:/4.(?:3|29{5}\d+)
-4.35:-1:/-4.(?:4|39{5}\d+)
-0.0065:-1:0
-0.0065:-2:/-0\.01|-1e-02
-0.0065:-3:/-0\.007|-7e-03
-0.0065:-4:/-0\.006(?:5|49{5}\d+)|-6\.5e-03
-0.0065:-5:/-0\.006(?:5|49{5}\d+)|-6\.5e-03
$Math::BigFloat::rnd_mode = 'odd'
+5.23:-1:/5.2(?:0{5}\d+)?
-5.23:-1:/-5.2(?:0{5}\d+)?
+5.27:-1:/5.(?:3|29{5}\d+)
-5.27:-1:/-5.(?:3|29{5}\d+)
+5.25:-1:/5.(?:2|29{5}\d+)
-5.25:-1:/-5.(?:2|29{5}\d+)
+5.35:-1:/5.(?:4|29{5}\d+)
-5.35:-1:/-5.(?:4|29{5}\d+)
-0.0065:-1:0
-0.0065:-2:/-0\.01|-1e-02
-0.0065:-3:/-0\.006|-6e-03
-0.0065:-4:/-0\.006(?:5|49{5}\d+)|-6\.5e-03
-0.0065:-5:/-0\.006(?:5|49{5}\d+)|-6\.5e-03
$Math::BigFloat::rnd_mode = 'even'
+6.23:-1:/6.2(?:0{5}\d+)?
-6.23:-1:/-6.2(?:0{5}\d+)?
+6.27:-1:/6.(?:3|29{5}\d+)
-6.27:-1:/-6.(?:3|29{5}\d+)
+6.25:-1:/6.(?:3(?:0{5}\d+)?|29{5}\d+)
-6.25:-1:/-6.(?:3(?:0{5}\d+)?|29{5}\d+)
+6.35:-1:/6.(?:3|39{5}\d+|29{8}\d+)
-6.35:-1:/-6.(?:3|39{5}\d+|29{8}\d+)
-0.0065:-1:0
-0.0065:-2:/-0\.01|-1e-02
-0.0065:-3:/-0\.007|-7e-03
-0.0065:-4:/-0\.006(?:5|49{5}\d+)|-6\.5e-03
-0.0065:-5:/-0\.006(?:5|49{5}\d+)|-6\.5e-03
&fcmp
abc:abc:
abc:+0:
+0:abc:
+0:+0:0
-1:+0:-1
+0:-1:1
+1:+0:1
+0:+1:-1
-1:+1:-1
+1:-1:1
-1:-1:0
+1:+1:0
-1.1:0:-1
+0:-1.1:1
+1.1:+0:1
+0:+1.1:-1
+123:+123:0
+123:+12:1
+12:+123:-1
-123:-123:0
-123:-12:-1
-12:-123:1
+123:+124:-1
+124:+123:1
-123:-124:1
-124:-123:-1
&fadd
abc:abc:NaN.
abc:+0:NaN.
+0:abc:NaN.
+0:+0:0.
+1:+0:1.
+0:+1:1.
+1:+1:2.
-1:+0:-1.
+0:-1:-1.
-1:-1:-2.
-1:+1:0.
+1:-1:0.
+9:+1:10.
+99:+1:100.
+999:+1:1000.
+9999:+1:10000.
+99999:+1:100000.
+999999:+1:1000000.
+9999999:+1:10000000.
+99999999:+1:100000000.
+999999999:+1:1000000000.
+9999999999:+1:10000000000.
+99999999999:+1:100000000000.
+10:-1:9.
+100:-1:99.
+1000:-1:999.
+10000:-1:9999.
+100000:-1:99999.
+1000000:-1:999999.
+10000000:-1:9999999.
+100000000:-1:99999999.
+1000000000:-1:999999999.
+10000000000:-1:9999999999.
+123456789:+987654321:1111111110.
-123456789:+987654321:864197532.
-123456789:-987654321:-1111111110.
+123456789:-987654321:-864197532.
&fsub
abc:abc:NaN.
abc:+0:NaN.
+0:abc:NaN.
+0:+0:0.
+1:+0:1.
+0:+1:-1.
+1:+1:0.
-1:+0:-1.
+0:-1:1.
-1:-1:0.
-1:+1:-2.
+1:-1:2.
+9:+1:8.
+99:+1:98.
+999:+1:998.
+9999:+1:9998.
+99999:+1:99998.
+999999:+1:999998.
+9999999:+1:9999998.
+99999999:+1:99999998.
+999999999:+1:999999998.
+9999999999:+1:9999999998.
+99999999999:+1:99999999998.
+10:-1:11.
+100:-1:101.
+1000:-1:1001.
+10000:-1:10001.
+100000:-1:100001.
+1000000:-1:1000001.
+10000000:-1:10000001.
+100000000:-1:100000001.
+1000000000:-1:1000000001.
+10000000000:-1:10000000001.
+123456789:+987654321:-864197532.
-123456789:+987654321:-1111111110.
-123456789:-987654321:864197532.
+123456789:-987654321:1111111110.
&fmul
abc:abc:NaN.
abc:+0:NaN.
+0:abc:NaN.
+0:+0:0.
+0:+1:0.
+1:+0:0.
+0:-1:0.
-1:+0:0.
+123456789123456789:+0:0.
+0:+123456789123456789:0.
-1:-1:1.
-1:+1:-1.
+1:-1:-1.
+1:+1:1.
+2:+3:6.
-2:+3:-6.
+2:-3:-6.
-2:-3:6.
+111:+111:12321.
+10101:+10101:102030201.
+1001001:+1001001:1002003002001.
+100010001:+100010001:10002000300020001.
+10000100001:+10000100001:100002000030000200001.
+11111111111:+9:99999999999.
+22222222222:+9:199999999998.
+33333333333:+9:299999999997.
+44444444444:+9:399999999996.
+55555555555:+9:499999999995.
+66666666666:+9:599999999994.
+77777777777:+9:699999999993.
+88888888888:+9:799999999992.
+99999999999:+9:899999999991.
&fdiv
abc:abc:NaN.
abc:+1:abc:NaN.
+1:abc:NaN.
+0:+0:NaN.
+0:+1:0.
+1:+0:NaN.
+0:-1:0.
-1:+0:NaN.
+1:+1:1.
-1:-1:1.
+1:-1:-1.
-1:+1:-1.
+1:+2:.5
+2:+1:2.
+10:+5:2.
+100:+4:25.
+1000:+8:125.
+10000:+16:625.
+10000:-16:-625.
+999999999999:+9:111111111111.
+999999999999:+99:10101010101.
+999999999999:+999:1001001001.
+999999999999:+9999:100010001.
+999999999999999:+99999:10000100001.
+1000000000:+9:111111111.1111111111111111111111111111111
+2000000000:+9:222222222.2222222222222222222222222222222
+3000000000:+9:333333333.3333333333333333333333333333333
+4000000000:+9:444444444.4444444444444444444444444444444
+5000000000:+9:555555555.5555555555555555555555555555556
+6000000000:+9:666666666.6666666666666666666666666666667
+7000000000:+9:777777777.7777777777777777777777777777778
+8000000000:+9:888888888.8888888888888888888888888888889
+9000000000:+9:1000000000.
+35500000:+113:314159.2920353982300884955752212389380531
+71000000:+226:314159.2920353982300884955752212389380531
+106500000:+339:314159.2920353982300884955752212389380531
+1000000000:+3:333333333.3333333333333333333333333333333
$Math::BigFloat::div_scale = 20
+1000000000:+9:111111111.11111111111
+2000000000:+9:222222222.22222222222
+3000000000:+9:333333333.33333333333
+4000000000:+9:444444444.44444444444
+5000000000:+9:555555555.55555555556
+6000000000:+9:666666666.66666666667
+7000000000:+9:777777777.77777777778
+8000000000:+9:888888888.88888888889
+9000000000:+9:1000000000.
+35500000:+113:314159.292035398230088
+71000000:+226:314159.292035398230088
+106500000:+339:314159.29203539823009
+1000000000:+3:333333333.33333333333
$Math::BigFloat::div_scale = 40
&fsqrt
+0:0
-1:/^(?i:0|\?|-?N\.?aNQ?)$
-2:/^(?i:0|\?|-?N\.?aNQ?)$
-16:/^(?i:0|\?|-?N\.?aNQ?)$
-123.456:/^(?i:0|\?|-?N\.?aNQ?)$
+1:1.
+1.44:1.2
+2:1.41421356237309504880168872420969807857
+4:2.
+16:4.
+100:10.
+123.456:11.11107555549866648462149404118219234119
+15241.383936:123.456
&fint
+0:+0
+1:+1
+11111111111111111234:+11111111111111111234
-1:-1
-11111111111111111234:-11111111111111111234
+0.3:+0
+1.3:+1
+23.3:+23
+12345678901234567890:+12345678901234567890
+12345678901234567.890:+12345678901234567
+12345678901234567890E13:+123456789012345678900000000000000
+12345678901234567.890E13:+123456789012345678900000000000
+12345678901234567890E-3:+12345678901234567
+12345678901234567.890E-3:+12345678901234
+12345678901234567890E-13:+1234567
+12345678901234567.890E-13:+1234
+12345678901234567890E-17:+123
+12345678901234567.890E-16:+1
+12345678901234567.890E-17:+0
+12345678901234567890E-19:+1
+12345678901234567890E-20:+0
+12345678901234567890E-21:+0
+12345678901234567890E-225:+0
-0:+0
-0.3:+0
-1.3:-1
-23.3:-23
-12345678901234567890:-12345678901234567890
-12345678901234567.890:-12345678901234567
-12345678901234567890E13:-123456789012345678900000000000000
-12345678901234567.890E13:-123456789012345678900000000000
-12345678901234567890E-3:-12345678901234567
-12345678901234567.890E-3:-12345678901234
-12345678901234567890E-13:-1234567
-12345678901234567.890E-13:-1234
-12345678901234567890E-17:-123
-12345678901234567.890E-16:-1
-12345678901234567.890E-17:+0
-12345678901234567890E-19:-1
-12345678901234567890E-20:+0
-12345678901234567890E-21:+0
-12345678901234567890E-225:+0
