$ErrorActionPreference = 'Stop'
function RGB($r,$g,$b){ return [int]($r + $g*256 + $b*65536) }
$blue=RGB 207 226 243; $yellow=RGB 255 229 153; $green=RGB 217 234 211; $dark=RGB 90 90 90; $red=RGB 179 0 0

$word = New-Object -ComObject Word.Application
$word.Visible=$false; $word.DisplayAlerts=0
$doc = $word.Documents.Add()
$ps=$doc.PageSetup; $ps.Orientation=1; $ps.PageWidth=1100; $ps.PageHeight=760
$ps.TopMargin=18; $ps.BottomMargin=18; $ps.LeftMargin=18; $ps.RightMargin=18
$sh=$doc.Shapes

# connector lines first (behind nodes)
$lines=@(
  @(230,380,230,250),@(230,250,230,130),
  @(870,380,870,250),@(870,250,870,130),
  @(230,380,430,300),@(430,300,870,380),
  @(230,380,550,380),@(550,380,870,380),
  @(230,380,430,460),@(430,460,870,380),
  @(550,620,700,520),@(700,520,870,380)
)
foreach($l in $lines){ $ln=$sh.AddLine($l[0],$l[1],$l[2],$l[3]); $ln.Line.ForeColor.RGB=$dark; $ln.Line.Weight=1.5 }

# attributes: text,left,top,entCX,entCY,isPK
$attrs=@(
  @('user_id',28,300,230,380,1),@('email',28,352,230,380,0),@('country',28,404,230,380,0),@('account_status',28,456,230,380,0),
  @('content_id',946,300,870,380,1),@('title',946,352,870,380,0),@('content_type',946,404,870,380,0),@('imdb_rating',946,456,870,380,0),
  @('plan_id',28,80,230,130,1),@('plan_name',28,140,230,130,0),@('monthly_price',360,76,230,130,0),@('max_screens',360,150,230,130,0),
  @('genre_id',946,80,870,130,1),@('genre_name',946,150,870,130,0),
  @('person_id',408,690,550,620,1),@('full_name',512,700,550,620,0),@('nationality',624,690,550,620,0),
  @('payment_status',28,230,230,250,0),@('progress_percent',360,200,430,300,0),@('cast_role',760,560,700,520,0)
)
$ow=126; $oh=40
foreach($a in $attrs){
  $ocx=$a[1]+$ow/2; $ocy=$a[2]+$oh/2
  $ln=$sh.AddLine($ocx,$ocy,$a[3],$a[4]); $ln.Line.ForeColor.RGB=$dark; $ln.Line.Weight=1.1
}

function Add-Node($type,$left,$top,$w,$h,$text,$fill,$fsize,$bold){
  $s=$sh.AddShape($type,$left,$top,$w,$h)
  $s.Fill.ForeColor.RGB=$fill; $s.Line.ForeColor.RGB=$dark; $s.Line.Weight=1.5
  $tr=$s.TextFrame.TextRange; $tr.Text=$text; $tr.Font.Size=$fsize; $tr.Font.Name='Calibri'
  $tr.Font.Bold=$bold; $tr.Font.Color=0; $tr.ParagraphFormat.Alignment=1
  $s.TextFrame.MarginTop=1; $s.TextFrame.MarginBottom=1
  return $s
}

# entities (rectangles) - font 12
$ents=@(@('User',164,352),@('Content',804,352),@("Subscription`nPlan",164,102),@('Genre',804,102),@('Person',484,592))
foreach($e in $ents){ [void](Add-Node 1 $e[1] $e[2] 132 56 $e[0] $blue 12 $true) }

# relationships (diamonds) - font 11, single line
$rels=@(@('Subscribes',164,212),@('Has Genre',804,212),@('Watches',364,262),@('Reviews',484,342),@('Favorites',364,422),@('Cast In',634,482))
foreach($r in $rels){ [void](Add-Node 4 $r[1] $r[2] 132 76 $r[0] $yellow 11 $false) }

# attributes (ovals) - font 10, PK underlined
foreach($a in $attrs){
  $s=Add-Node 9 $a[1] $a[2] $ow $oh $a[0] $green 10 $false
  if($a[5] -eq 1){ $s.TextFrame.TextRange.Font.Underline=1 }
}

# cardinality labels - font 13 red bold
function Add-Label($text,$mx,$my){
  $tb=$sh.AddTextbox(1,$mx-12,$my-10,26,22); $tb.Line.Visible=$false; $tb.Fill.Visible=$false
  $tr=$tb.TextFrame.TextRange; $tr.Text=$text; $tr.Font.Size=13; $tr.Font.Bold=$true
  $tr.Font.Name='Calibri'; $tr.Font.Color=$red; $tr.ParagraphFormat.Alignment=1
  $tb.TextFrame.MarginTop=0; $tb.TextFrame.MarginBottom=0
}
$labels=@(
  @('N',230,315),@('1',230,190),@('M',870,315),@('N',870,190),
  @('M',330,335),@('N',650,335),@('M',388,366),@('N',712,366),
  @('M',330,425),@('N',650,425),@('M',625,565),@('N',788,445)
)
foreach($lb in $labels){ Add-Label $lb[0] $lb[1] $lb[2] }

# title
$tt=$sh.AddTextbox(1,330,10,440,30); $tt.Line.Visible=$false; $tt.Fill.Visible=$false
$ttr=$tt.TextFrame.TextRange; $ttr.Text='VIEWFLIX - Entity Relationship Diagram (Chen Notation)'
$ttr.Font.Size=16; $ttr.Font.Bold=$true; $ttr.Font.Name='Calibri'; $ttr.ParagraphFormat.Alignment=1

$out='C:\Users\HUAWEI\streaming_db\VIEWFLIX_ER_Diagram.docx'
$pdf='C:\Users\HUAWEI\streaming_db\VIEWFLIX_ER_Diagram.pdf'
$doc.SaveAs([ref]$out); $doc.SaveAs([ref]$pdf,[ref]17)
$doc.Close($false); $word.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($word)|Out-Null
"DONE"
