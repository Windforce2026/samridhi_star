param()

$ErrorActionPreference = 'Stop'
$shellPath = 'C:\Users\hjha7\AppData\Local\Temp\opencode\shell.html'
$txtDir   = 'C:\Users\hjha7\AppData\Local\Temp\opencode\star\txt'
$root     = 'C:\Users\hjha7\Downloads\saveweb2zip-com-www-starhospitalslg-com'
$shell    = [System.IO.File]::ReadAllText($shellPath)
if(-not $shell.Contains('<!--PAGEBODY-->')){ throw 'PAGEBODY placeholder missing' }

$PHONE_EMERGENCY = '+91 74780 66817'
$PHONE_APPT      = '+91 80160 48838'
$EMAIL           = 'starhospitalslg@gmail.com'
$ADDR            = '1st Floor, Sikkim Plaza, 3rd Mile Sevoke Road, Siliguri, West Bengal 734001'
$GOOGLE_REVIEW_URL  = 'https://www.google.com/maps/place/Samridhi+Multispeciality+Hospital/@26.7571983,88.4412994,17z/data=!4m8!3m7!1s0x39e4410793e8db97:0x9c8fa278ca11b085!8m2!3d26.7571983!4d88.4412994!9m1!1b1'
$GOOGLE_LOCATION_URL = 'https://www.google.com/maps/dir/?api=1&amp;destination=Samridhi+Neuro+%26+ENT+Multispeciality+Hospital&amp;destination_place_id=ChIJl9vokwdB5DkRhbARyniij5w'

$shell = $shell.Replace('https://rb.gy/cx03o0', $GOOGLE_REVIEW_URL)
$shell = $shell.Replace('https://maps.app.goo.gl/B8NUJkRijaRWiMcu7', $GOOGLE_LOCATION_URL)

function Get-Txt([string]$name){
  $p = Join-Path $txtDir ($name + '.txt')
  if(Test-Path -LiteralPath $p){ return [System.IO.File]::ReadAllText($p) }
  return ''
}

function ConvertTo-BlockHtml([string]$txt,[switch]$sectionMode){
  if(-not $txt.Trim()){ return '<p>Content coming soon.</p>' }
  $blocks = @($txt -split '(?:\r?\n){2,}')
  $sb = New-Object System.Text.StringBuilder
  $pendQ = $false
  foreach($b in $blocks){
    $lines = @($b -split '\r?\n' | ForEach-Object { (($_ -replace '<[^>]*>','') -replace '<[^>]*','').Trim() } | Where-Object { $_ })
    if($lines.Count -eq 0){ continue }
    $first = $lines[0]
    if($first -match '^\s*<' ){ continue }
    if($first -match '^class="' -or $first -eq 'Home'){ continue }
    if($first -match '^((About|Facilities|Careers|Career|Contact|Testimonials|Doctors?|FAQs?|Laboratory Services|Diagnostic Services|Support Services|Patient.s Corner|Resources|Media|Video Gallery|Infographics|Events &amp; Updates|Press Release|Blog)\s*)$'){ continue }
    $t = ($lines -join ' ')
    if($t -match '(Asian Highway|Send An Appointment|Copyrights?|Powered by|Quick Links|Google Reviews|Our Location|Follow :|Consultation Call Us|Enter Captcha|Appointment Date|You agree to receive)'){ continue }
    if($first.EndsWith('?')){
      if($pendQ){ [void]$sb.Append('</p></details>') }
      [void]$sb.Append("<details class=""faq-card""><summary>$first</summary><p>")
      $pendQ = $true
      continue
    }
    if($pendQ){
      [void]$sb.Append("$t</p></details>")
      $pendQ = $false
      continue
    }
    if($lines.Count -gt 1){
      if($first -match '\?\s*$'){
        [void]$sb.Append("<details class=""faq-card""><summary>$first</summary><p>$($lines[1..($lines.Count-1)] -join ' ')</p></details>")
        continue
      }
      $isLabel = ($first.Length -le 55 -and $first -notmatch '[\.!?:]$' -and $first.Split(' ').Count -le 5)
      if($isLabel){
        [void]$sb.Append("<h4 class=""mt-3 mb-2"" style=""color:var(--main-color);font-weight:700;"">$first</h4>")
        [void]$sb.Append('<ul class="mb-3">')
        for($i=1;$i -lt $lines.Count;$i++){ [void]$sb.Append("<li>$($lines[$i])</li>") }
        [void]$sb.Append('</ul>')
      } else {
        [void]$sb.Append("<p>$t</p>")
      }
      continue
    }
    $qi = $t.IndexOf('?')
    if($qi -gt 8 -and ($t.Length - $qi) -gt 8){
      [void]$sb.Append("<details class=""faq-card""><summary>$($t.Substring(0,$qi+1))</summary><p>$($t.Substring($qi+1).Trim())</p></details>")
      continue
    }
    if($t -match '^[^\.!?]{1,45}:\s*$'){
      [void]$sb.Append("<h3 class=""sec-title mt-4 mb-2"" style=""font-size:20px;"">$($t.TrimEnd(':'))</h3>")
    } elseif ($t.Length -le 70 -and $t -match '^[A-Z0-9][A-Za-z0-9 ,&/()''-]*$' -and -not $t.EndsWith('.')){
      [void]$sb.Append("<h4 class=""mt-3 mb-2"" style=""color:var(--main-color);font-weight:700;"">$t</h4>")
    } else {
      [void]$sb.Append("<p>$t</p>")
    }
  }
  if($pendQ){ [void]$sb.Append('</p></details>') }
  return $sb.ToString()
}

$DEPT_COVER = @{
 'obstetrics-and-gynaecology'='1705649022Cgynecology-cover.jpg'
 'cardiology-and-cardiac-surgery'='1705651196Ccardiology-cover.jpg'
 'advanced-laparoscopy-general-and-cancer-surgery'='1705651367CLaparoscopy.jpg'
 'gastroenterology'='1705651695CGastroenterology.jpg'
 'neurology-and-neurosurgery'='1705651856CNeurology.jpg'
 'urology-andrology-and-uro-oncology'='1705652107CUrology.jpg'
 'paediatrics-and-neonatology'='1705652230CPaediatrics.jpg'
 'dermatology'='1705652583CDermatology.jpg'
 'plastic-and-reconstructive-surgery'='1705656061CReconstructive-Surgery.jpg'
 'physiotherapy'='1705656158CPhysiotherapy.jpg'
 'pulmonology'='1705658676CPulmonology.jpg'
 'spine-surgery'='1705658942Cspine-surgery.jpg'
 'paediatric-surgery'='1705659230Cpaediatric-surgery.jpg'
 'orthopaedics-and-joint-replacement-surgery'='1705659462COrthopaedics.jpg'
 'internal-medicine'='1705660240CInternal-Medicine.jpg'
 'trauma-surgery'='1705660866Ctrauma-surgery.jpg'
 'icu-and-critical-care'='1705661026CCritical-Care.jpg'
 'maxillofacial-surgery'='1705661299CMaxillofacial-Surgery.jpg'
 'ent'='1705661470Cent.jpg'
 'endocrinology'='1705661872CEndocrinology.jpg'
 'nephrology'='1705662321CNephrology.jpg'
 'microbiology'='1705663079CMicrobiology.jpg'
 'biochemistry'='1705663432CBiochemistry.jpg'
 'pathology'='1705663627CPathology.jpg'
 'radiology-and-interventional-radiology'='1705663769Cradiology.jpg'
 'emergency'='1705663929Cemergency.jpg'
 'special-clinic'='1705665724CSpecial-Clinic.jpg'
 'family-medicine'='1705665868CFamily-Medicine.jpg'
 'psychiatry'='1705666155CPsychiatry.jpg'
 'haematology'='1705666423CHaematology.jpg'
 'general-medicine'='1714056680Ccard.jpg'
}

$AVATAR = 'images/176060971117262061151705477547doctor.svg'
$DOCTYPE = @(
 @{dept='general-medicine'; slug='dr-swapan-kumar-khan'; name='Dr. Swapan Kumar Khan'; qual='MBBS, MD, Fellowship in Diabetology &amp; Critical Care'; img='images/176060971117262061151705477547doctor.svg'; about='Specialist physician with advanced training in Diabetology and Critical Care, providing comprehensive medical diagnosis and management.'; quals=@('MBBS','MD (Physiology)','Fellowship in Diabetology &amp; Critical Care'); exps=@('Comprehensive internal medicine consultation','Management of diabetes &amp; metabolic disorders','Critical care &amp; emergency management','Preventive health check-ups')},
 @{dept='pulmonology'; slug='dr-rebekah-subba'; name='Dr. Rebekah Subba'; qual='MBBS, MD (Chest Medicine), Consultant Pulmonologist'; img='images/doctor/dr-rebekah-subba.jpeg'; about='Consultant Pulmonologist and Critical Care physician with broad experience across academic and tertiary-care institutions.'; quals=@('MBBS','MD (Chest / Pulmonary Medicine)','Certifications in critical care'); exps=@('Respiratory critical care','Management of complex lung conditions','Pulmonary consultations &amp; evaluation','Critical care for the critically ill')},
 @{dept='pulmonology'; slug='dr-sayer-miridha'; name='Dr. Sayer Miridha'; qual='MBBS, MD, Consultant Pulmonologist'; img='images/doctor/dr-sayer-miridha.jpg'; about='Consultant Pulmonologist providing comprehensive respiratory, allergy and preventive care.'; quals=@('MBBS','MD (Pulmonary Medicine)'); exps=@('Comprehensive respiratory care &amp; evaluation','Bronchoscopy &amp; interventional pulmonary procedures','Allergy evaluation &amp; management','Chronic disease counselling for asthma, COPD &amp; lung infections')},
 @{dept='neurology-and-neurosurgery'; slug='dr-sayed-khizar-uz-zaman'; name='Dr. Sayed Khizar Uz Zaman'; qual='MBBS, DrNB (Neurosurgery)'; img='images/doctor/dr-sayed-khizar-uz-zaman.jpeg'; about='Neurosurgeon with DrNB and international fellowships, specialising in complex brain and spine procedures.'; quals=@('MBBS','DrNB (Neurosurgery)','MNAMS, FISNI, FIPN, FIESB, FISBS, ECMINT (Oxford, UK)'); exps=@('Brain &amp; spine surgery','Complex neurovascular and skull-base procedures','Minimally invasive neurosurgery','Neuro-critical care')},
 @{dept='neurology-and-neurosurgery'; slug='dr-vishram-s-pandey'; name='Dr. Vishram S. Pandey'; qual='MBBS, MS, MCh (Neuro Surgery)'; img='images/176060971117262061151705477547doctor.svg'; about='Neurosurgeon with training at NIMHANS, specialising in brain and spine surgery.'; quals=@('MBBS','MS (General Surgery)','MCh (Neuro Surgery)','Training at NIMHANS, Bangalore'); exps=@('Brain &amp; spine surgery','Management of neurological &amp; neurosurgical conditions','Trauma &amp; emergency neurosurgical care','Pre-operative &amp; post-operative neurosurgical care')},
 @{dept='advanced-laparoscopy-general-and-cancer-surgery'; slug='dr-adarsh-bhardwaj'; name='Dr. Adarsh Bhardwaj'; qual='MBBS, MS (General Surgery), DNB, FMAS'; img='images/176060971117262061151705477547doctor.svg'; about='General and laparoscopic surgeon with advanced training in minimally invasive surgery.'; quals=@('MBBS','MS (General Surgery)','DNB (General Surgery)','FMAS - Advanced Laparoscopic &amp; Gastrosurgery'); exps=@('Advanced laparoscopic &amp; gastrosurgery','Minimally invasive general surgery','Hernia, gall bladder &amp; appendix surgery','Surgical care for cancer patients')},
 @{dept='advanced-laparoscopy-general-and-cancer-surgery'; slug='dr-penzin-d-bhutia'; name='Dr. Penzin D Bhutia'; qual='MBBS, MS (General &amp; Laparoscopic Surgery)'; img='images/176060971117262061151705477547doctor.svg'; about='General and laparoscopic surgeon providing comprehensive surgical care.'; quals=@('MBBS','MS (General &amp; Laparoscopic Surgery)'); exps=@('General &amp; laparoscopic surgery','Minimally invasive procedures','Emergency &amp; elective surgical care')},
 @{dept='ent'; slug='dr-sandeep-ghosh'; name='Dr. Sandeep Ghosh'; qual='MBBS, MS (ENT)'; img='images/176060971117262061151705477547doctor.svg'; about='ENT and head and neck surgeon known for thorough, caring treatment.'; quals=@('MBBS','MS (ENT)'); exps=@('ENT &amp; head and neck surgery','Ear, nose &amp; throat care for adults and children','Management of sinus, tonsil, throat &amp; hearing problems','Outpatient ENT consultations')},
 @{dept='ent'; slug='dr-parth-pratim-saha'; name='Dr. Parth Pratim Saha'; qual='MBBS, MS (ENT) &amp; Head and Neck Surgery'; img='images/176060971117262061151705477547doctor.svg'; about='ENT and head and neck surgeon providing care for adults and children.'; quals=@('MBBS','MS (ENT) &amp; Head and Neck Surgery'); exps=@('ENT &amp; head and neck surgery','Ear, nose &amp; throat consultation for adults and children','Sinus, tonsil &amp; throat procedures')},
 @{dept='ent'; slug='dr-sachin-prasad'; name='Dr. Sachin Prasad'; qual='MBBS, MS (ENT)'; img='images/176060971117262061151705477547doctor.svg'; about='ENT specialist providing comprehensive ear, nose and throat care.'; quals=@('MBBS','MS (ENT)'); exps=@('ENT consultation &amp; treatment','Ear, nose &amp; throat procedures','Sinus &amp; hearing care')},
 @{dept='ent'; slug='dr-arunava-ghosh'; name='Dr. Arunava Ghosh'; qual='MBBS, MS (ENT)'; img='images/176060971117262061151705477547doctor.svg'; about='ENT specialist managing common and complex ear, nose and throat conditions for patients of all ages.'; quals=@('MBBS','MS (ENT)'); exps=@('ENT consultations &amp; treatment','Management of ear, nose &amp; throat infections','Sinonasal &amp; throat procedures')},
 @{dept='plastic-and-reconstructive-surgery'; slug='dr-amit-kumar-chowdhary'; name='Dr. Amit Kumar Chowdhary'; qual='MBBS, MS, MCh (Plastic Surgery)'; img='images/doctor/dr-amit-kumar-chowdhary.jpeg'; about='Plastic and reconstructive surgeon offering restorative and aesthetic surgical care.'; quals=@('MBBS','MS (General Surgery)','MCh (Plastic Surgery)'); exps=@('Reconstructive surgery after trauma, burns &amp; cancer','Aesthetic &amp; cosmetic procedures','Microvascular &amp; flap surgery','Personalised, compassionate aftercare')},
 @{dept='nephrology'; slug='dr-ratan-kumar-agarwal'; name='Dr. Ratan Kumar Agarwal'; qual='MBBS, DNB (Nephrology)'; img='images/176060971117262061151705477547doctor.svg'; about='Nephrologist with 15 years of experience in dialysis, renal biopsy, kidney transplantation and peritoneal dialysis.'; quals=@('MBBS','DNB (Nephrology)'); exps=@('Dialysis &amp; peritoneal dialysis','Renal biopsy &amp; kidney care','Management of complex medical &amp; renal cases','Kidney transplantation care')},
 @{dept='urology-andrology-and-uro-oncology'; slug='dr-washim-mollah'; name='Dr. Washim Mollah'; qual='MBBS, MS, MCh (Urology)'; img='images/176060971117262061151705477547doctor.svg'; about='Urologist with a focus on minimally invasive stone and urinary tract surgery.'; quals=@('MBBS','MS (General Surgery)','FAMS','MCh (Urology)'); exps=@('Retrograde Intrarenal Surgery (RIRS) for kidney stones','Minimally invasive urological procedures','Kidney stone, prostate &amp; urinary tract care','Published research in the Indian Journal of Urology')},
 @{dept='cardiology-and-cardiac-surgery'; slug='dr-rajesh-kumar'; name='Dr. Rajesh Kumar'; qual='MBBS, DIP (Cardio)'; img='images/176060971117262061151705477547doctor.svg'; about='Cardiologist providing comprehensive cardiac evaluation and care.'; quals=@('MBBS','DIP (Cardio)'); exps=@('Comprehensive cardiac evaluation','Management of coronary &amp; heart rhythm disorders','Preventive cardiology','Cardiac emergency care')},
 @{dept='cardiology-and-cardiac-surgery'; slug='dr-kailash-kumar-goyal'; name='Dr. Kailash Kumar Goyal'; qual='MBBS, MD (Cardiology)'; img='images/176060971117262061151705477547doctor.svg'; about='Senior consultant cardiologist with extensive clinical and procedural experience.'; quals=@('MBBS','MD (General/Internal Medicine)','DM (Cardiology)'); exps=@('Comprehensive clinical cardiology care &amp; evaluation','Interventional cardiology procedures','Management of coronary, valvular &amp; rhythm disorders','Pre-operative cardiac assessment &amp; follow-up')},
 @{dept='dermatology'; slug='dr-suman-gupta'; name='Dr. Suman Gupta'; qual='MBBS, MD, DM (Dermatology)'; img='images/176060971117262061151705477547doctor.svg'; about='Dermatologist providing comprehensive skin and hair care.'; quals=@('MBBS','MD','DM (Dermatology)'); exps=@('Medical &amp; cosmetic dermatology','Skin, hair &amp; nail disorder management','Dermatological procedures','Preventive skin care')},
 @{dept='orthopaedics-and-joint-replacement-surgery'; slug='dr-mrityunjay-roy'; name='Dr. Mrityunjay Roy'; qual='MBBS, MS (Orthopaedics)'; img='images/176060971117262061151705477547doctor.svg'; about='Orthopedic surgeon with over 1,000 joint replacement procedures to his credit.'; quals=@('MBBS','MS (Orthopedics)','Fellowship in Arthroscopy &amp; Sports Medicine','Fellowship in Shoulder &amp; Elbow Surgery (Arthroscopy &amp; Arthroplasty)'); exps=@('Joint replacement surgery - knee, hip, shoulder &amp; elbow','Total elbow replacement (first in the region)','Arthroscopy &amp; sports injury management','Trauma &amp; fracture care')},
 @{dept='orthopaedics-and-joint-replacement-surgery'; slug='dr-ranjit-kumar-singh'; name='Dr. Ranjit Kumar Singh'; qual='MBBS, MS (Orthopaedics), MCh (Joint Replacement)'; img='images/176060971117262061151705477547doctor.svg'; about='Orthopedic surgeon with over 10 years of clinical practice.'; quals=@('MBBS','MS (Orthopaedics)','MCh (Joint Replacement)','FIMS - International Fellowship'); exps=@('Orthopedic care &amp; joint replacement','Management of bone, joint &amp; trauma conditions','Surgical &amp; non-surgical treatment planning','Rehabilitation &amp; post-operative guidance')},
 @{dept='gastroenterology'; slug='dr-prabhat-ranjan'; name='Dr. Prabhat Ranjan'; qual='MBBS, MD, DM (Gastroenterology)'; img='images/doctor/dr-prabhat-ranjan.jpeg'; about='Medical gastroenterologist with over 15 years of expertise in advanced endoscopic procedures.'; quals=@('MBBS','MD (Internal/General Medicine)','DM (Gastroenterology) - S.N. Medical College, Jodhpur'); exps=@('Endoscopic Retrograde Cholangiopancreatography (ERCP)','Diagnostic &amp; therapeutic Endoscopic Ultrasound (EUS)','Double Balloon Enteroscopy','Third space endoscopy - ESD and POEM','MRCP &amp; FibroScan')},
 @{dept='obstetrics-and-gynaecology'; slug='dr-sumit-das'; name='Dr. Sumit Das'; qual='MBBS, MS, DNB (Obstetrics &amp; Gynaecology)'; img='images/176060971117262061151705477547doctor.svg'; about='Obstetrician and gynaecologist with expertise in high-risk pregnancy care and laparoscopic surgery.'; quals=@('MBBS','MS (Obstetrics &amp; Gynaecology)','DNB (Obstetrics &amp; Gynaecology)'); exps=@('Obstetrics - prenatal care, high-risk deliveries &amp; reproductive health','Management of pregnancy-related disorders, irregular periods &amp; ovarian cysts','Laparoscopic gynaecological surgeries &amp; pelvic procedures','Routine obstetric &amp; gynaecological interventions')},
 @{dept='obstetrics-and-gynaecology'; slug='dr-sindhu-bala'; name='Dr. Sindhu Bala'; qual='MBBS, MD, DGO (Obstetrics &amp; Gynaecology)'; img='images/176060971117262061151705477547doctor.svg'; about='Gynaecologist, obstetrician and IVF / infertility specialist.'; quals=@('MBBS','MD (Obstetrics &amp; Gynaecology)','DGO','Fellowship in In-Vitro Fertilization (IVF)'); exps=@('IVF, IUI, egg/embryo donation &amp; TESA','Management of high-risk pregnancies','Laparoscopic surgery, irregular periods &amp; ovarian cysts','Preventive care &amp; gynaecological cancer care')},
 @{dept='obstetrics-and-gynaecology'; slug='dr-neelam-singla'; name='Dr. Neelam Singla'; qual='MBBS, MD, DGO (Obstetrics &amp; Gynaecology)'; img='images/176060971117262061151705477547doctor.svg'; about='Obstetrician, gynaecologist and cosmetic gynaecologist.'; quals=@('MBBS','MD / MS (Obstetrics &amp; Gynaecology)','DGO','Diploma in Functional &amp; Regenerative Cosmetic Gynaecology'); exps=@('Obstetrics &amp; pregnancy care - antenatal, normal &amp; cesarean deliveries, high-risk pregnancy management','Gynaecological care - menstrual disorders, PCOD/PCOS, fibroids &amp; menopausal health','Infertility evaluation &amp; personalised treatment plans','Functional &amp; cosmetic gynaecology','Preventive oncology - Pap smears, HPV testing &amp; colposcopy')},
 @{dept='psychiatry'; slug='dr-rajesh-thakur'; name='Dr. Rajesh Thakur'; qual='MBBS, MD, DM (Psychiatry)'; img='images/176060971117262061151705477547doctor.svg'; about='Psychiatrist providing comprehensive mental health care.'; quals=@('MBBS','MD','DM (Psychiatry)'); exps=@('Psychiatric consultation &amp; therapy','Management of depression, anxiety &amp; stress disorders','De-addiction &amp; counselling','Child &amp; adolescent mental health')},
 @{dept='maxillofacial-surgery'; slug='dr-subhajit-das'; name='Dr. Subhajit Das'; qual='BDS, MDS (Oral &amp; Maxillofacial Surgery)'; img='images/doctor/dr-subhajit-das.jpeg'; about='Oral and maxillofacial surgeon with experience in implantology and facial aesthetic surgery.'; quals=@('BDS','MDS (Oral &amp; Maxillofacial Surgery)','Fellowship in Implantology','Fellowship in Facial Aesthetic Surgery'); exps=@('Oral &amp; maxillofacial surgery','Implantology &amp; dental implants','Facial aesthetic surgery','Orthognathic &amp; corrective jaw procedures')},
 @{dept='advanced-laparoscopy-general-and-cancer-surgery'; slug='dr-t-n-mitra'; name='Dr. T.N. Mitra'; qual='MBBS, MD, DM (Oncology)'; img='images/176060971117262061151705477547doctor.svg'; about='Medical oncologist providing comprehensive cancer care.'; quals=@('MBBS','MD','DM (Oncology)'); exps=@('Medical oncology &amp; chemotherapy','Cancer diagnosis &amp; staging','Hematological malignancies','Supportive &amp; palliative cancer care')},
 @{dept='paediatrics-and-neonatology'; slug='dr-gunjan-agarwal'; name='Dr. Gunjan Agarwal'; qual='MBBS, MD (Paediatrics)'; img='images/doctor/dr-gunjan-agarwal.jpg'; about='Paediatrician with 14+ years of experience in newborn and child care.'; quals=@('MBBS','MD (Paediatrics)','FIP - Fellowship in Paediatrics','FNACC - Fellowship in Neonatology','PGPN - Global Paediatric Health (Boston Children''s / Harvard)'); exps=@('Newborn &amp; neonatal care','Immunisation &amp; vaccination support','Growth, nutrition &amp; developmental monitoring','Management of childhood illnesses','14+ years of clinical experience')},
 @{dept='maxillofacial-surgery'; slug='dr-sourav-bose'; name='Dr. Sourav Bose'; qual='BDS, MDS (Prosthodontics &amp; Implantology)'; img='images/176060971117262061151705477547doctor.svg'; about='Dental surgeon specialising in prosthodontics, implantology and root canal treatment.'; quals=@('B.D.S.','M.D.S. - Prosthodontics, Crown &amp; Bridge &amp; Implantology','Certified RCT Specialist (PDGE)'); exps=@('Prosthodontics, crowns, bridges &amp; dental implants','Root canal treatment (RCT) &amp; restorations','Cosmetic &amp; restorative dental care')}
)
function Get-DocCards([string]$dept){
  if([string]::IsNullOrWhiteSpace($dept)){
    $docs = @($DOCTYPE)
  } else {
    $docs = @($DOCTYPE | Where-Object { $_.dept -eq $dept })
  }
  if($docs.Count -eq 0){ return '' }
  $sb = New-Object System.Text.StringBuilder
  foreach($d in $docs){
    [void]$sb.Append("<div class=""col-6 col-md-6 col-lg-6 col-xl-4 my-3""><div class=""docblock rounded-5 ofhidden border2 bg-whitee coolbg shadow-sm height100 prelative""><a href=""doctor/$($d.slug)/index.html"" class=""d-block p-3 pb-0 text-center rounded-3 bg-white""><img src=""images/doctor/placeholder.jpg"" data-src=""$($d.img)"" data-srcset=""$($d.img)"" alt=""$($d.name)"" class=""max mb-2 rounded-3 lazy"" width=""230"" height=""256""></a><hr class=""op1 mt-0""><div class=""text-center px-3""><h4 class=""font18 fw-600 mb-1""><a href=""doctor/$($d.slug)/index.html"" class=""d-block th-color"">$($d.name)</a></h4><p class=""lh-22 font14 m-0 fw-500 color333"">$($d.qual)</p></div><div class=""sanko""><div class=""full px-3 pb-2 d-flex align-items-center justify-content-center""><a href=""doctor/$($d.slug)/index.html"" class=""btn btn-sm btn3 lh-20 font14 outline"">Know More</a></div></div></div></div>")
  }
  return $sb.ToString()
}

function Get-DoctorBody($doc){
  $quals = ($doc.quals | ForEach-Object { "<li>$_</li>" }) -join "`n"
  $exps = ($doc.exps | ForEach-Object { "<li>$_</li>" }) -join "`n"
  return @"
<section class="sec-pad"><div class="container"><div class="row">
<div class="col-12 col-lg-8">
<div class="side-card prelative">
<div class="text-center"><div class="ratio" style="max-width:230px;margin:0 auto;"><img src="images/doctor/placeholder.jpg" data-src="$($doc.img)" data-srcset="$($doc.img)" alt="$($doc.name)" class="max rounded-3 lazy" width="230" height="256"></div></div>
<h4 class="text-center mt-3 mb-1 fw-600">$($doc.name)</h4>
<p class="text-center text-muted mb-0">$($DEF_DISPLAY[$doc.dept])</p>
</div>
<h4 class="fw-600 mb-2 mt-4"><i class="bi bi-person-heart me-2 th-color"></i>About</h4>
<p class="lh-22 mb-0">$($doc.about)</p>
<h4 class="fw-600 mb-2 mt-4"><i class="bi bi-award me-2 th-color"></i>Qualifications &amp; Training</h4>
<ul class="pjustify mb-0">$quals</ul>
<h4 class="fw-600 mb-2 mt-4"><i class="bi bi-graph-up-arrow me-2 th-color"></i>Clinical Expertise &amp; Specializations</h4>
<ul class="pjustify mb-0">$exps</ul>
<a href="appointment"><img src="images/advt-samridhi.jpg" alt="Book An Appointment at Samridhi Hospital" class="max mt-4 rounded-3 border2"></a>
</div>
<div class="col-12 col-lg-4">$(Get-Sidebar)</div>
</div></div></section>
"@
}

function Get-DeptBody([string]$display,[string]$slug,[string]$crumb2){
  $txt = Get-Txt ('dep_' + $slug)
  $cover = $DEPT_COVER[$slug]
  if(-not $cover){ $cover = '1705651196Ccardiology-cover.jpg' }
  $blocks = @($txt -split '(?:\r?\n){2,}')
  $introSb = New-Object System.Text.StringBuilder
  $restOut = New-Object System.Collections.Generic.List[string]
  $inRest = $false
  foreach($b in $blocks){
    $l = @($b -split '\r?\n' | ForEach-Object { (($_ -replace '<[^>]*>','') -replace '<[^>]*','').Trim() } | Where-Object { $_ })
    if($l.Count -eq 0){ continue }
    $f = $l[0]
    $isHeading = ($f.Length -le 60 -and $f -notmatch '[.!?:]$' -and ($f -split ' ').Count -le 6 -and $f -notmatch '^(<|class=)')
    if($isHeading -or $f.EndsWith('?')){ $inRest = $true }
    if($inRest){
      $restOut.Add(($l -join "`n"))
    } else {
      [void]$introSb.Append((($l -join ' ')))
      [void]$introSb.Append("`n`n")
    }
  }
  $intro = $introSb.ToString().Trim()
  $body  = ($restOut -join "`n`n")
  $body  = $body -replace 'Know More',' '
  $body  = $body -replace '(?i)Frequently Asked Questions on [A-Za-z0-9 &,()/]+',''
  $body  = $body -replace '(?m)^[ ]*[^\r\n]{1,80} Doctors\r?\n',''
  $body  = $body -replace '(?m)^[ ]*Dr\. [^\r\n]*\r?\n',''
  $body  = $body -replace '(?m)^[ ]*(?i)(MBBS|MS|MD|DM|DGO|MCH|DNB|FNB|FRCS|MRCP)((,|, )[^,\r\n]*)*\r?\n',''
  $body  = [regex]::Replace($body,'(?:\r?\n){3,}',"`n`n")
  if(-not $intro){
    $introHtml = "<p>$display at Samridhi Hospital Siliguri - comprehensive, patient-centric care delivered by experienced specialists.</p>"
  } else {
    $introHtml = ConvertTo-BlockHtml $intro
  }
  $html = @"
<section class="insider prelative obg bg-cover bg-center" data-bg="images/department/$cover">
<div class="container prelative zindex1"><div class="text-center-xs">
<h1 class="h1 mb-2 fw-600 white">$display</h1>
<div class="crumb white"><a href="index.html">Home</a> <i class="bi bi-chevron-right"></i> <a href="departments">Departments</a> <i class="bi bi-chevron-right"></i> $display</div>
</div></div>
</section>
<section class="py-4 py-lg-5 min70">
<div class="container">
<div class="row">
<div class="col-12 col-lg-8 col-md-12 my-3 pe-lg-4 pe-xl-5">
<div class="pjustify text-justify mb-3">$introHtml</div>
<div class="pb-4"><img src="images/department/$cover" alt="$display at Samridhi Hospital" class="max rounded-5 border2" width="900" height="450" loading="lazy"></div>
<div class="descriptionofdept pjustify">$(ConvertTo-BlockHtml $body)</div>
$( $dcards = Get-DocCards $slug; if($dcards){ "<h3 class=""fw-600 h4 mt-4 mt-lg-5 mb-3 p-3 border22 rounded-5 bglight"">$display Doctors</h3><div class=""row"">$dcards</div>" })
<a href="appointment"><img src="images/advt-samridhi.jpg" alt="Book An Appointment at Samridhi Hospital" class="max mt-4 mt-lg-5 rounded-3 border2"></a>
<div class="clearfix"></div>
</div>
<div class="col-12 col-lg-4 col-md-12 my-3 sidebar">
<div class="p-3 coolbg2 rounded-5 border2 shadow1 kiatro prelative">
<h4 class="h5 font18 text-uppercase fw-600 mb-2 p-2">All Departments</h4>
<hr class="op1 mt-0">
<ul class="nostyle font16 fw-500 limb5 bhaisahab">
$allDeptLinks
</ul>
</div>
<div class="clearfix my-4"></div>
<div class="parsley bg-white p-3 p-md-4 shadow1 rounded-5 border2">
<div class="text-center p-2"><h4 class="h5 fw-600 text-uppercase mb-3">Book An Appointment</h4></div>
<form action="#" method="post" class="bt1 parsley">
<div class="row g-2">
<div class="col-12"><input type="text" class="form-control" name="name" placeholder="Full Name *" required></div>
<div class="col-12"><input type="tel" class="form-control" name="phone" placeholder="Phone No *" required></div>
<div class="col-12"><input type="email" class="form-control" name="email" placeholder="Email ID"></div>
<div class="col-12"><select class="form-select" name="dept"><option>Select Department</option><option>$display</option></select></div>
<div class="col-12"><textarea class="form-control" name="msg" rows="3" placeholder="Your Message"></textarea></div>
<div class="col-12"><button type="submit" class="btn w-100" style="background:linear-gradient(90deg,#FFC107,#D4AF37);color:#0B2B66;font-weight:800;border:0;">SEND ENQUIRY</button></div>
</div>
</form>
</div>
</div>
</div>
</div>
</section>
"@
  return $html
}

function Get-Sidebar([string]$dept,[switch]$NoForm,[switch]$NoEmergency){
  $deps = @('cardiology-and-cardiac-surgery','gastroenterology','neurology-and-neurosurgery','obstetrics-and-gynaecology','orthopaedics-and-joint-replacement-surgery','urology-andrology-and-uro-oncology','paediatrics-and-neonatology','ent')
  $links = ''
  foreach($d in $deps){ $links += "<a href=""department/$d""><strong>$($d -replace '-',' ')</strong></a>" }
  $form = ''
  if(-not $NoForm){
    $dark = ''
    if($dept){ $dark = "<option selected>$dept</option>" }
    $form = @"
<div class="side-card mb-4">
<h5>Book a Consultation</h5>
<p>Reach our care team today and we will get back to you shortly.</p>
<form class="row g-3" action="#" method="post">
<div class="col-12"><input type="text" class="form-control" name="name" placeholder="Full Name *" required></div>
<div class="col-12"><input type="tel" class="form-control" name="phone" placeholder="Phone No *" required></div>
<div class="col-12"><select class="form-select" name="dept"><option>Select Department</option>$dark</select></div>
<div class="col-12"><textarea class="form-control" name="msg" rows="3" placeholder="Your Message"></textarea></div>
<div class="col-12"><button type="submit" class="btn w-100 d-block" style="background:linear-gradient(90deg,#FFC107,#D4AF37);color:#0B2B66;font-weight:800;border:0;">SEND ENQUIRY</button></div>
</form>
</div>
"@
  }
  $emergency = ''
  if(-not $NoEmergency){
    $emergency = @"
<div class="side-card mb-4">
<h5>24x7 Emergency</h5>
<p>Immediate care round the clock, no prior appointment needed.</p>
<p class="mb-1"><i class="bi bi-telephone-fill"></i> <a href="tel:$PHONE_EMERGENCY">$PHONE_EMERGENCY</a></p>
<p class="mb-0"><i class="bi bi-calendar-check"></i> Appointments: <a href="tel:$PHONE_APPT">$PHONE_APPT</a></p>
</div>
"@
  }
  return @"
$form
$emergency
<div class="side-card">
<h5>Popular Departments</h5>
$links
</div>
"@
}

$DEF_DISPLAY = @{
 'advanced-laparoscopy-general-and-cancer-surgery'='Advanced Laparoscopy, General &amp; Cancer Surgery'
 'biochemistry'='Biochemistry'
 'cardiology-and-cardiac-surgery'='Cardiology and Cardiac Surgery'
 'dermatology'='Dermatology'
 'emergency'='Emergency'
 'endocrinology'='Endocrinology'
 'ent'='ENT'
 'family-medicine'='Family Medicine'
 'gastroenterology'='Gastroenterology'
 'general-medicine'='General Medicine'
 'haematology'='Haematology'
 'icu-and-critical-care'='ICU and Critical Care'
 'internal-medicine'='Internal Medicine'
 'maxillofacial-surgery'='Maxillofacial Surgery'
 'microbiology'='Microbiology'
 'nephrology'='Nephrology'
 'neurology-and-neurosurgery'='Neurology and Neurosurgery'
 'obstetrics-and-gynaecology'='Obstetrics and Gynaecology'
 'orthopaedics-and-joint-replacement-surgery'='Orthopaedics &amp; Joint Replacement Surgery'
 'paediatric-surgery'='Paediatric Surgery'
 'paediatrics-and-neonatology'='Paediatrics and Neonatology'
 'pathology'='Pathology'
 'physiotherapy'='Physiotherapy'
 'plastic-and-reconstructive-surgery'='Plastic &amp; Reconstructive Surgery'
 'psychiatry'='Psychiatry'
 'pulmonology'='Pulmonology'
 'radiology-and-interventional-radiology'='Radiology &amp; Interventional Radiology'
 'special-clinic'='Special Clinic'
 'spine-surgery'='Spine Surgery'
 'trauma-surgery'='Trauma Surgery'
 'urology-andrology-and-uro-oncology'='Urology, Andrology and Uro Oncology'
}
$DEPT_SLUGS = $DEF_DISPLAY.Keys | Sort-Object

$BANNER_BG = @{}
Get-ChildItem $txtDir -Filter *.txt | ForEach-Object {
  $first = Get-Content $_.FullName -TotalCount 1
  $m = [regex]::Match($first, 'data-bg="([^"]+)"')
  if($m.Success){
    $BANNER_BG["$($_.BaseName)\index.html"] = $m.Groups[1].Value
  }
}

function New-Page{
  param([string]$Rel,[string]$Title,[string]$Desc,[string]$Body,[int]$Depth=1,[switch]$NoPrefooter)
  $p = $('..\' * $Depth) -replace '\\','/'
  $ob = ([regex]::Matches($Body,'<div(?=[ >])')).Count - ([regex]::Matches($Body,'</div>')).Count
  if($ob -gt 0){ $Body += ('</div>' * $ob) }
  if($Body -match '<div class="page-inner">'){
    $bgbg = $BANNER_BG[$Rel]
    if(-not $bgbg){ $bgbg = 'images/inner/inner.jpg' }
    $Body = [regex]::Replace($Body,
      '<div class="page-inner">.*?<h1>(.*?)</h1><div class="crumb">(.*?)</div></div></div>',
      { param($mm)
        "<section class=`"insider prelative obg bg-cover bg-center`" data-bg=`"$bgbg`">" +
        "<div class=`"container prelative zindex1`"><div class=`"text-center-xs`">" +
        "<h1 class=`"h1 mb-2 fw-600 white`">$($mm.Groups[1].Value)</h1>" +
        "<div class=`"crumb white`">$($mm.Groups[2].Value)</div></div></div></section>"
      })
  }
  $html = $shell
  $html = $html.Replace('<!--PAGEBODY-->', $Body)
  $html = [regex]::Replace($html,'<title>.*?</title>', "<title>$Title</title>")
  $html = [regex]::Replace($html,'<meta name="description" content="[^"]*"', "<meta name=`"description`" content=`"$Desc`"")
  $html = [regex]::Replace($html,'<meta property="og:title" content="[^"]*"', "<meta property=`"og:title`" content=`"$Title`"")
  $html = [regex]::Replace($html,'<meta property="og:description" content="[^"]*"', "<meta property=`"og:description`" content=`"$Desc`"")
  if($Depth -ge 1){
    $html = [regex]::Replace($html,'(?<=(?:src|href|data-bg|data-src|data-srcset)=")(?!/|http|#|mailto:|tel:|javascript:|data:)', $p)
  }
  $html = [regex]::Replace($html,'(<a[^>]*?)href="https://www\.starhospitalslg\.com"','$1' + 'href="' + $p + 'index.html"')
  $html = $html -replace 'Star Health','Samridhi'
  $html = $html -replace 'Star Hospital','Samridhi Hospital'
  $html = $html -replace '\bStar\b','Samridhi'
  $html = $html -replace '1800 123 8044','+91 74780 66817'
  $html = $html -replace '80010 06060','+91 80160 48838'
  $html = $html -replace '8001006060','8016048838'
  $html = $html -replace 'Asian Highway-2[^<]*?734004','1st Floor, Sikkim Plaza, 3rd Mile Sevoke Road, Siliguri, West Bengal 734001'
  $html = [regex]::Replace($html,'href="[^"]*(?:facebook\.com/starhospitalslg|instagram\.com/starhospitalslg|youtube\.com/@starhospitalslg|linkedin\.com)[^"]*"','')
  if($NoPrefooter){
    $si = $html.IndexOf('<section class="prelative bglight py-4 py-lg-5">')
    if($si -ge 0){
      $se = $html.IndexOf('</section>', $si)
      if($se -ge 0){ $html = $html.Remove($si, $se + 10 - $si) }
    }
  }
  $dest = Join-Path $root (($Rel -replace '\\','/') -replace '/','\')
  $d = Split-Path -Parent $dest
  if(-not (Test-Path -LiteralPath $d)){ New-Item -ItemType Directory -Path $d -Force | Out-Null }
  [System.IO.File]::WriteAllText($dest,$html,[System.Text.UTF8Encoding]::new($false))
  "{0,-45} {1,7} bytes  D{2}" -f $Rel,$html.Length,$Depth
}

# ============= CORE PAGES =============
$starDeptOrder = @('obstetrics-and-gynaecology','cardiology-and-cardiac-surgery','advanced-laparoscopy-general-and-cancer-surgery','gastroenterology','neurology-and-neurosurgery','urology-andrology-and-uro-oncology','paediatrics-and-neonatology','dermatology','plastic-and-reconstructive-surgery','physiotherapy','pulmonology','spine-surgery','paediatric-surgery','orthopaedics-and-joint-replacement-surgery','internal-medicine','trauma-surgery','icu-and-critical-care','maxillofacial-surgery','ent','endocrinology','nephrology','microbiology','biochemistry','pathology','radiology-and-interventional-radiology','emergency','special-clinic','family-medicine','psychiatry','haematology','general-medicine')
$allDeptLinks = ($starDeptOrder | ForEach-Object { $d = $_; "<li class=""bg-white1 p-1 px-2""><a class=""d-block"" href=""department/$d"">$($DEF_DISPLAY[$d]) <i class=""bi bi-arrow-right-short float-end""></i></a></li>" }) -join "`n"

$txtAbout = Get-Txt 'about'
$intro = $txtAbout.Substring($txtAbout.IndexOf('At Star Hospital, we take our commitment'))
$intro = $intro.Substring(0, $intro.IndexOf('Powered by')).Replace('Star Hospital','Samridhi Hospital')

New-Page -Rel 'about\index.html' -Title 'About Samridhi Hospital | Neuro &amp; ENT Multispeciality Hospital Siliguri' -Desc 'Samridhi Hospital Siliguri is a 30-bedded multispeciality hospital offering advanced neuro & ENT care, diagnostics, ICU and 24x7 emergency.' -NoPrefooter -Body @"
<div class="about-hero-sec">
<div class="container">
<div class="about-hero">
<img class="about-hero-img" src="images/about-hero.jpg" alt="About Samridhi Hospital - More Than Just a Hospital, We Are Your Family">
<div class="about-shade"></div>
<div class="about-content">
<p class="about-tag"><span class="tagline-white">More Than Just a Hospital</span><br><span class="tagline-gold">We Are Your Family</span></p>
</div>
</div>
</div>
</div>
<section class="sec-pad">
<div class="container">
<div class="row">
<div class="col-12">
$(ConvertTo-BlockHtml $intro)
</div>
</div>
</div>
</section>
"@

New-Page -Rel 'departments\index.html' -Title 'Departments - Samridhi Hospital Siliguri' -Desc 'Explore our 30+ medical departments at Samridhi Hospital Siliguri - cardiology, neuro, ENT, ortho, gynae and more.' -Body @"
<div class="page-inner"><span class="page-wm"></span><div class="container"><h1>Our Departments</h1><div class="crumb"><a href="index.html">Home</a> <i class="bi bi-chevron-right"></i> Departments</div></div></div>
<section class="sec-pad">
<div class="container">
<div class="sec-title text-center mb-5"><h2>Specialities <span class="grd-text">at Samridhi Hospital</span></h2><p>Comprehensive, patient-centric care delivered by expert specialists.</p></div>
<div class="row g-4">
$( ($DEPT_SLUGS | ForEach-Object { $d = $_; $disp = $DEF_DISPLAY[$d] -replace '&amp;','&amp;'; "<div class=""col-12 col-sm-6 col-lg-4""><div class=""dept-card""><i class=""bi bi-hospital""></i><h3>$disp</h3><p>Specialist care with advanced diagnostics for every need.</p><a href=""department/$d"">Know More <i class=""bi bi-arrow-right""></i></a></div></div>" }) -join "`n" )
</div>
</div>
</section>
"@

New-Page -Rel 'laboratory-services\index.html' -Title 'Laboratory Services - Samridhi Hospital Siliguri' -Desc 'Accurate pathology, biochemistry, histopathology, microbiology and haematology testing at Samridhi Hospital Siliguri.' -Body @"
<div class="page-inner"><span class="page-wm"></span><div class="container"><h1>Laboratory Services</h1><div class="crumb"><a href="index.html">Home</a> <i class="bi bi-chevron-right"></i> Services / Laboratory Services</div></div></div>
<section class="sec-pad">
<div class="container">
<div class="row">
<div class="col-12 col-lg-8">$(ConvertTo-BlockHtml (Get-Txt 'laboratory-services'))</div>
<div class="col-12 col-lg-4">$(Get-Sidebar)</div>
</div>
</div>
</section>
"@

$DIAG = @(
 @{slug='pathology'; name='Pathology'; icon='bi-microscope'; short='Complete laboratory &amp; pathology services including haematology, biochemistry and microbiology.'; img='pathology.webp'; about='Comprehensive laboratory and pathology services including haematology, biochemistry, microbiology, histopathology and clinical pathology with accredited processing for accurate, reliable results.'; offers=@('Haematology &amp; biochemistry','Microbiology &amp; histopathology','Clinical pathology testing','Accredited sample processing'); benefits=@('Precise, reliable results','Fast report turnaround','Doctor-reviewed reporting','Comfortable sample collection')},
 @{slug='ct-scan'; name='CT Scan'; icon='bi-radiation'; short='Multi-slice CT imaging for trauma, neurological, cardiac and abdominal diagnosis.'; img=''; about='Multi-slice computed tomography with contrast and non-contrast protocols for trauma, neurological, cardiac and abdominal imaging with rapid reconstruction.'; offers=@('Trauma &amp; neuro imaging','Cardiac &amp; abdominal CT','Contrast &amp; non-contrast','Rapid 3D reconstruction'); benefits=@('High-detail images','Fast scan &amp; reporting','Advanced multi-slice scanner','Specialist interpretation')},
 @{slug='x-ray'; name='X-Ray'; icon='bi-x-ray'; short='Low-dose digital radiography for skeletal, chest and abdominal imaging.'; img='x-ray.jpg'; about='Digital radiography with low-dose imaging for skeletal, chest and abdominal examinations, with high-resolution prints available instantly for your physician.'; offers=@('Skeletal &amp; chest imaging','Abdominal radiography','Low-dose digital capture','Instant high-res prints'); benefits=@('Minimal radiation exposure','Rapid, clear images','Same-visit printouts','Experienced technicians')},
 @{slug='ultrasonography'; name='Ultrasonography (USG)'; icon='bi-activity'; short='Real-time ultrasound for obstetric, abdominal, pelvic, thyroid and Doppler studies.'; img='ultrasonography.jpg'; about='Real-time ultrasound imaging including obstetric, abdominal, pelvic, thyroid and Doppler studies performed by experienced sonographers on advanced equipment.'; offers=@('Obstetric &amp; pelvic scans','Abdominal &amp; thyroid imaging','Doppler studies','Real-time ultrasound'); benefits=@('Non-invasive &amp; painless','Experienced sonographers','Detailed reporting','Comfortable patient care')},
 @{slug='ecg'; name='ECG'; icon='bi-heart-pulse'; short='12-lead ECG for cardiac rhythm assessment and pre-operative screening.'; img=''; about='12-lead electrocardiogram for rapid cardiac rhythm assessment, acute MI detection and pre-operative screening with immediate digital reporting.'; offers=@('12-lead rhythm recording','Acute MI detection','Pre-operative screening','Immediate digital reporting'); benefits=@('Painless &amp; non-invasive','Fast, same-visit report','Critical cardiac screening','Cardiologist consultation')},
 @{slug='eeg'; name='EEG'; icon='bi-brain'; short='Brain-wave recording for seizure, epilepsy and sleep disorder evaluation.'; img='eeg.jpeg'; about='Electroencephalogram recording for seizure evaluation, epilepsy monitoring, sleep disorder assessment and neurological diagnostics.'; offers=@('Seizure evaluation','Epilepsy monitoring','Sleep disorder assessment','Neurological diagnostics'); benefits=@('Safe, non-invasive test','Comfortable procedure','Expert interpretation','Guides treatment plan')},
 @{slug='endoscopy'; name='Endoscopy'; icon='bi-camera'; short='Upper GI endoscopy, colonoscopy and ERCP with high-definition video endoscopes.'; img='endoscopy.jpg'; about='Diagnostic and therapeutic upper GI endoscopy, colonoscopy and ERCP performed by trained gastroenterologists using high-definition video endoscopes.'; offers=@('Upper GI endoscopy','ERCP procedures','Therapeutic intervention','High-definition video scope'); benefits=@('Minimally invasive','Trained gastroenterologists','Clear high-definition view','Faster recovery')},
 @{slug='colonoscopy'; name='Colonoscopy'; icon='bi-notes'; short='Complete colon examination for colorectal screening, polyp detection and biopsy.'; img='colonoscopy.jpg'; about='Complete colon examination for colorectal screening, polyp detection and biopsy with sedation support and same-day preliminary findings.'; offers=@('Colorectal screening','Polyp detection &amp; biopsy','Sedation-supported procedure','Same-day preliminary findings'); benefits=@('Complete colon examination','Comfortable sedation','Early detection focus','Timely preliminary report')}
)

New-Page -Rel 'diagnostic-services\index.html' -Title 'Diagnostic Services - Samridhi Hospital Siliguri' -Desc 'CT Scan, Digital X-Ray, Ultrasound (USG), ECG, EEG, Endoscopy, Colonoscopy and Pathology diagnostics at Samridhi Hospital Siliguri.' -Body @"
<div class="page-inner"><span class="page-wm"></span><div class="container"><h1>Diagnostic Services</h1><div class="crumb"><a href="index.html">Home</a> <i class="bi bi-chevron-right"></i> Services / Diagnostic Services</div></div></div>
<section class="sec-pad">
<div class="container">
<div class="row">
<div class="col-12 col-lg-8">
<p>Samridhi Hospital offers a complete range of diagnostic services under one roof &mdash; from digital imaging and cardiac screening tests to laboratory and endoscopic procedures. Our advanced equipment, experienced specialists and rapid reporting help your doctor reach the right diagnosis, faster.</p>
<div class="row g-4 mt-1">
$( ($DIAG | ForEach-Object { $d = $_; "<div class=""col-12 col-sm-6 col-lg-4""><div class=""dept-card""><i class=""bi $($d.icon)""></i><h3>$($d.name)</h3><p>$($d.short)</p><a href=""diagnostic-services/$($d.slug)"">Know More <i class=""bi bi-arrow-right""></i></a></div></div>" }) -join "`n" )
</div>
</div>
<div class="col-12 col-lg-4">$(Get-Sidebar)</div>
</div>
</div>
</section>
"@

$DIAG | ForEach-Object {
$d = $_
New-Page -Rel "diagnostic-services\$($d.slug)\index.html" -Depth 2 -Title "$($d.name) - Samridhi Hospital Siliguri" -Desc $d.about -Body @"
<div class="page-inner"><span class="page-wm"></span><div class="container"><h1>$($d.name)</h1><div class="crumb"><a href="index.html">Home</a> <i class="bi bi-chevron-right"></i> Services / Diagnostic Services / $($d.name)</div></div></div>
<section class="sec-pad">
<div class="container">
<div class="row">
<div class="col-12 col-lg-8">
$(if($d.img){ "<img src=""images/diagnostics/$($d.img)"" alt=""$($d.name) at Samridhi Hospital"" class=""img-fluid rounded-4 mb-4"" loading=""lazy"">" } else { '' })
<h3 class="sec-title" style="font-size:20px;">About this service</h3>
<p>$($d.about)</p>
<h3 class="sec-title" style="font-size:20px;">What we offer</h3>
<ul class="point">
$( $d.offers | ForEach-Object { "<li><i class=""bi bi-check2-circle""></i> $_</li>" } )
</ul>
<h3 class="sec-title" style="font-size:20px;">Patient benefits</h3>
<ul class="point">
$( $d.benefits | ForEach-Object { "<li><i class=""bi bi-check2-circle""></i> $_</li>" } )
</ul>
<div class="side-card" style="margin-top:24px;background:linear-gradient(90deg,#0B2B66,#123a8a);color:#fff;border-radius:14px;padding:20px;">
<h5 style="color:#FFC107;">Book your test today</h5>
<p class="mb-1">Fast, accurate and doctor-reviewed results.</p>
<p class="mb-0"><i class="bi bi-telephone-fill"></i> <a href="tel:$PHONE_EMERGENCY" style="color:#fff;">$PHONE_EMERGENCY</a></p>
</div>
</div>
<div class="col-12 col-lg-4">$(Get-Sidebar)</div>
</div>
</div>
</section>
"@
}

New-Page -Rel 'support-services\index.html' -Title 'Support Services - Samridhi Hospital Siliguri' -Desc '24x7 emergency, modular OT, ICU/NICU, pharmacy, dialysis, cathlab and canteen at Samridhi Hospital Siliguri.' -Body @"
<div class="page-inner"><span class="page-wm"></span><div class="container"><h1>Support Services</h1><div class="crumb"><a href="index.html">Home</a> <i class="bi bi-chevron-right"></i> Services / Support Services</div></div></div>
<section class="py-4 py-lg-5 min70">
<div class="container">
<div class="row">
<div class="col-12 col-lg-8 col-md-12 my-3 pe-lg-4 pe-xl-5 pjustify">
<div class="faci">
<p>Samridhi Health also offers its patients with extra support services to ensure that they get the best healthcare solutions from us. From state-of-the-art facilities to 24x7 emergency care, our support service is always there to provide the best treatment against unexpected medical conditions.</p>
<h2 class="h5 fw-600">24x7 Emergency &amp; Trauma Care</h2>
<p>Whether you have been in a traffic accident or suffered from a severe health condition, our team of emergency and trauma care is always there to manage your condition with the best quality healthcare service.</p>
<img src="images/services/trauma-care.jpg" alt="24x7 Emergency and Trauma Care at Samridhi Hospital" class="w-100 mb-3 rounded-3 border2" loading="lazy">
<h3 class="h5 fw-600">Ultra Modular Operation Theatre</h3>
<p>Samridhi Hospital features an ultra-modular operation theatre equipped with modern technology and infrastructure that allows us to provide the best surgical treatment to our patients.</p>
<img src="images/services/ot.jpg" alt="Ultra Modular Operation Theatre at Samridhi Hospital" class="w-100 mb-3 rounded-3 border2" loading="lazy">
<h3 class="h5 fw-600">Critical Care Units (ICU, NICU, HDU)</h3>
<p>We are well equipped with a wide range of critical care units that are designed to provide the utmost care to patients suffering from life-threatening conditions.</p>
<h3 class="h5 fw-600">Pharmacy</h3>
<p>Samridhi Hospital also offers its patients with hospital pharmacy headed by senior pharmacists that is responsible for dispensing medications and monitoring the drug dosage forms.</p>
<img src="images/services/pharmacy.jpg" alt="Pharmacy at Samridhi Hospital" class="w-100 mb-3 rounded-3 border2" loading="lazy">
<h3 class="h5 fw-600">Dialysis</h3>
<p>Dialysis is a process of filtering excess fluid from the body of a person whose kidney has stopped working. Our department of nephrology features a dialysis unit that is used to filter the extra fluids of people suffering from kidney failure.</p>
<img src="images/services/dialysis.jpg" alt="Dialysis at Samridhi Hospital" class="w-100 mb-3 rounded-3 border2" loading="lazy">
<h3 class="h5 fw-600">Canteen</h3>
<p>Our Hospital also houses a canteen headed by a chef who understands the meaning of healthy nutrition and its benefits for the healing of patients. From freshly prepared soup to a healthy meal the canteen serves a range of dishes that will allow our patients to heal quickly.</p>
<h3 class="h5 fw-600">Cathlab</h3>
<p>Our Cathlab department is headed by an expert cardiologist who performs several minimally invasive tests and procedures that help to understand and diagnose cardiovascular disease.</p>
</div>
</div>
<div class="col-12 col-lg-4 col-md-12 my-3 sidebar">
<div class="p-3 coolbg2 rounded-5 border2 shadow1 kiatro prelative">
<h4 class="h5 font18 text-uppercase fw-600 mb-2 p-2">All Departments</h4>
<hr class="op1 mt-0">
<ul class="nostyle font16 fw-500 limb5 bhaisahab">
$allDeptLinks
</ul>
</div>
<div class="clearfix my-4"></div>
<div class="parsley bg-white p-3 p-md-4 shadow1 rounded-5 border2">
<div class="text-center p-2"><h4 class="h5 fw-600 text-uppercase mb-3">Book An Appointment</h4></div>
<form action="#" method="post" class="bt1 parsley">
<div class="row g-2">
<div class="col-12"><input type="text" class="form-control" name="name" placeholder="Full Name *" required></div>
<div class="col-12"><input type="tel" class="form-control" name="phone" placeholder="Phone No *" required></div>
<div class="col-12"><input type="email" class="form-control" name="email" placeholder="Email ID"></div>
<div class="col-12"><input type="date" class="form-control" name="date"></div>
<div class="col-12"><textarea class="form-control" name="msg" rows="3" placeholder="Your Message"></textarea></div>
<div class="col-12"><button type="submit" class="btn w-100" style="background:linear-gradient(90deg,#FFC107,#D4AF37);color:#0B2B66;font-weight:800;border:0;">SEND ENQUIRY</button></div>
</div>
</form>
</div>
</div>
</div>
</div>
</section>
"@

New-Page -Rel 'facilities\index.html' -Title 'Facilities - Samridhi Hospital Siliguri' -Desc 'Out-patient &amp; in-patient care, 24/7 emergency, pharmacy, critical care, OT and diagnostics at Samridhi Hospital Siliguri.' -Body @"
<div class="page-inner"><span class="page-wm"></span><div class="container"><h1>Hospital Facilities</h1><div class="crumb"><a href="index.html">Home</a> <i class="bi bi-chevron-right"></i> Facilities</div></div></div>
<section class="sec-pad">
<div class="container">
<div class="row">
<div class="col-12 col-lg-8">
<p>At Samridhi Hospital we offer a wide range of comprehensive healthcare services that cater to the diverse needs of our patients. Staffed by a team of highly skilled healthcare professionals - experienced doctors, nurses and support staff - our cutting-edge facilities and advanced technology enable us to deliver the highest standards of patient-centred care. You can trust us to work tirelessly to ensure your well-being and provide you with the best possible healthcare experience.</p>
<h3 class="sec-title mt-4 mb-2" style="font-size:20px;">Out-Patient and In-Patient</h3>
<p>We deliver premium quality, patient-centric facilities. We achieve this through our holistic services and smart patient-centric arrangements, which are accessible to everyone.</p>
<img src="images/facilities/ipd.jpg" alt="Out-Patient and In-Patient at Samridhi Hospital" style="width:100%;border-radius:14px;margin:10px 0 6px;" loading="lazy">
<h3 class="sec-title mt-4 mb-2" style="font-size:20px;">24/7 Emergency Services</h3>
<p>The Emergency Casualty Department is here to provide immediate assistance without the need for prior appointments. Staffed by a team of experienced emergency medicine specialists, it is always ready to meet your urgent medical needs with prompt and expert care.</p>
<img src="images/facilities/emergency.jpg" alt="24/7 Emergency Services at Samridhi Hospital" style="width:100%;border-radius:14px;margin:10px 0 6px;" loading="lazy">
<h3 class="sec-title mt-4 mb-2" style="font-size:20px;">Round The Clock Pharmacy</h3>
<p>Delivering timely medical services and medications to both inpatients and outpatients, in addition to supporting healthcare professionals in their care of patients.</p>
<h3 class="sec-title mt-4 mb-2" style="font-size:20px;">Laboratory and Pathology</h3>
<p>For optimizing patient care and addressing the complexities of the healthcare system, our highly specialized laboratory and clinical testing services play an essential role, ensuring quick and accurate results for every patient.</p>
<img src="images/facilities/laboratory.jpg" alt="Laboratory and Pathology at Samridhi Hospital" style="width:100%;border-radius:14px;margin:10px 0 6px;" loading="lazy">
<h3 class="sec-title mt-4 mb-2" style="font-size:20px;">Critical Care for All</h3>
<p>Managing patients facing acute, life-threatening illnesses or injuries is the core focus of the Critical Care Department, which stands as a multidisciplinary healthcare speciality.</p>
<h3 class="sec-title mt-4 mb-2" style="font-size:20px;">Well-Equipped Operation Theatre</h3>
<p>With our fully-equipped operation theatre, we offer comprehensive and advanced surgical facilities, ensuring safe and specialized surgeries for all complexity levels.</p>
<img src="images/facilities/operation-theatre.jpg" alt="Well-Equipped Operation Theatre at Samridhi Hospital" style="width:100%;border-radius:14px;margin:10px 0 6px;" loading="lazy">
<h3 class="sec-title mt-4 mb-2" style="font-size:20px;">Precise Diagnostic</h3>
<p>We deliver timely, cost-effective and premium diagnostic care within secure and safe environments with full confidence.</p>
<img src="images/facilities/diagnostic.jpg" alt="Precise Diagnostic at Samridhi Hospital" style="width:100%;border-radius:14px;margin:10px 0 6px;" loading="lazy">
<h3 class="sec-title mt-4 mb-2" style="font-size:20px;">Doctors-On-Call</h3>
<p>You can count on our 24/7 Doctor-on-Call Service to provide top-notch healthcare services anytime, any day of the week, ensuring that you receive the best possible care.</p>
</div>
<div class="col-12 col-lg-4">
<div class="p-3 coolbg2 rounded-5 border2 shadow1 kiatro prelative mb-4">
<h4 class="h5 font18 text-uppercase fw-600 mb-2 p-2">All Departments</h4>
<hr class="op1 mt-0">
<ul class="nostyle font16 fw-500 limb5 bhaisahab">
$allDeptLinks
</ul>
</div>
<div class="parsley bg-white p-3 p-md-4 shadow1 rounded-5 border2">
<div class="text-center p-2"><h4 class="h5 fw-600 text-uppercase mb-3">Book An Appointment</h4></div>
<form action="#" method="post" class="bt1 parsley">
<div class="row g-2">
<div class="col-12"><input type="text" class="form-control" name="name" placeholder="Full Name *" required></div>
<div class="col-12"><input type="tel" class="form-control" name="phone" placeholder="Phone No *" required></div>
<div class="col-12"><input type="email" class="form-control" name="email" placeholder="Email ID"></div>
<div class="col-12"><input type="date" class="form-control" name="date"></div>
<div class="col-12"><textarea class="form-control" name="msg" rows="3" placeholder="Your Message"></textarea></div>
<div class="col-12"><button type="submit" class="btn w-100" style="background:linear-gradient(90deg,#FFC107,#D4AF37);color:#0B2B66;font-weight:800;border:0;">SEND ENQUIRY</button></div>
</div>
</form>
</div>
</div>
</div>
</div>
</section>
"@

New-Page -Rel 'faq\index.html' -Title 'FAQs - Samridhi Hospital Siliguri' -Desc 'Frequently asked questions about appointments, insurance, admission, facilities and services at Samridhi Hospital Siliguri.' -Body @"
<div class="page-inner"><span class="page-wm"></span><div class="container"><h1>Frequently Asked Questions</h1><div class="crumb"><a href="index.html">Home</a> <i class="bi bi-chevron-right"></i> FAQs</div></div></div>
<section class="sec-pad">
<div class="container">
<div class="row">
<div class="col-12 col-lg-8">$(ConvertTo-BlockHtml (Get-Txt 'faq'))</div>
<div class="col-12 col-lg-4">$(Get-Sidebar)</div>
</div>
</div>
</section>
"@

# ============= DOCTORS =============
$docDepts = @($DOCTYPE | ForEach-Object { $_.dept } | Sort-Object -Unique)
$docHtml = ''
foreach($s in $docDepts){ $docHtml += "<a class=""btn btn-sm m-1"" style=""border:1px solid #D4AF37;color:#0B2B66;font-weight:700;"" href=""doctor/$s"">$($DEF_DISPLAY[$s])</a>" }
New-Page -Rel 'doctors\index.html' -Title 'Our Doctors &amp; Consultants - Samridhi Hospital Siliguri' -Desc 'Samridhi Hospital Siliguri is home to a team of experienced doctors and consultants across 16+ specialities.' -Body @"
<div class="page-inner"><span class="page-wm"></span><div class="container"><h1>Our Best Doctors &amp; Consultants</h1><div class="crumb"><a href="index.html">Home</a> <i class="bi bi-chevron-right"></i> Doctors</div></div></div>
<section class="sec-pad">
<div class="container">
<div class="sec-title text-center mb-5"><h2>Experts <span class="grd-text">you can trust</span></h2><p>Meet the specialist consultants leading each department at Samridhi Hospital, Siliguri.</p></div>
<p class="text-center mb-4">Select a speciality to view its specialist doctors:</p>
<div class="text-center mb-5">$docHtml</div>
<h3 class="fw-600 h4 mb-4 text-center">Meet Our Doctors</h3>
<div class="row">$(Get-DocCards '')</div>
</div>
</section>
"@

# ============= APPOINTMENT =============
New-Page -Rel 'appointment\index.html' -Title 'Book Appointment - Samridhi Hospital Siliguri' -Desc 'Book an appointment online at Samridhi Hospital Siliguri. Call +91 80160 48838 for instant appointment scheduling.' -Body @"
<div class="page-inner"><span class="page-wm"></span><div class="container"><h1>Book an Appointment</h1><div class="crumb"><a href="index.html">Home</a> <i class="bi bi-chevron-right"></i> Appointment</div></div></div>
<section class="sec-pad">
<div class="container">
<div class="row">
<div class="col-12 col-lg-8">
<div class="side-card">
<h5>Send An Appointment Enquiry</h5>
<p>Submit your details to consult with Samridhi Hospital, and we will get back to you asap.</p>
<form action="#" method="post">
<div class="row g-3">
<div class="col-md-6"><label class="form-label">Full Name *</label><input type="text" class="form-control" name="name" required></div>
<div class="col-md-6"><label class="form-label">Phone No *</label><input type="tel" class="form-control" name="phone" required></div>
<div class="col-md-6"><label class="form-label">Email ID</label><input type="email" class="form-control" name="email"></div>
<div class="col-md-6"><label class="form-label">Preferred Date</label><input type="date" class="form-control" name="date"></div>
<div class="col-12"><label class="form-label">Select Treatment / Department</label><select class="form-select" name="dept">$($DEPT_SLUGS | ForEach-Object { "<option>$($DEF_DISPLAY[$_])</option>" } | Out-String)</select></div>
<div class="col-12"><label class="form-label">Address</label><input type="text" class="form-control" name="address"></div>
<div class="col-12"><label class="form-label">Message</label><textarea class="form-control" name="msg" rows="3"></textarea></div>
<div class="col-12"><button type="submit" class="btn w-100" style="background:linear-gradient(90deg,#FFC107,#D4AF37);color:#0B2B66;font-weight:800;border:0;">SEND ENQUIRY</button></div>
</div>
</form>
</div>
</div>
<div class="col-12 col-lg-4">$(Get-Sidebar)</div>
</div>
</div>
</section>
"@

# ============= CONTACT =============
New-Page -Rel 'contact\index.html' -Title 'Contact Us - Samridhi Hospital Siliguri' -Desc 'Contact Samridhi Hospital Siliguri at 1st Floor, Sikkim Plaza, 3rd Mile Sevoke Road. Emergency: +91 74780 66817.' -Body @"
<div class="page-inner"><span class="page-wm"></span><div class="container"><h1>Contact Us</h1><div class="crumb"><a href="index.html">Home</a> <i class="bi bi-chevron-right"></i> Contact</div></div></div>
<section class="sec-pad">
<div class="container">
<div class="sec-title text-center mb-5"><h2>Get In <span class="grd-text">Touch</span></h2><p>Reach out to us for appointments, enquiries or emergencies - we are here to help.</p></div>
<div class="row g-4 mb-5">
<div class="col-12 col-md-6 col-lg-4"><div class="side-card h-100 text-center"><i class="bi bi-geo-alt-fill" style="font-size:32px;color:#D4AF37;"></i><h5 class="mt-3 mb-2">Our Address</h5><p class="small mb-0">1st Floor, Sikkim Plaza,<br>3rd Mile Sevoke Road,<br>Siliguri, West Bengal 734001</p></div></div>
<div class="col-12 col-md-6 col-lg-4"><div class="side-card h-100 text-center"><i class="bi bi-telephone-fill" style="font-size:32px;color:#D4AF37;"></i><h5 class="mt-3 mb-2">Call Us</h5><p class="small mb-0">Emergency (24x7):<br><a href="tel:$PHONE_EMERGENCY">$PHONE_EMERGENCY</a></p><p class="small mb-0">Appointments:<br><a href="tel:$PHONE_APPT">$PHONE_APPT</a></p></div></div>
<div class="col-12 col-md-6 col-lg-4"><div class="side-card h-100 text-center"><i class="bi bi-envelope-fill" style="font-size:32px;color:#D4AF37;"></i><h5 class="mt-3 mb-2">Email Us</h5><p class="small mb-0"><a href="mailto:$EMAIL">$EMAIL</a></p><p class="small mb-0">We reply within 24 hours.</p></div></div>
</div>
<div class="row g-4">
<div class="col-12 col-lg-7">
<div class="side-card">
<h5>Send Us a Message</h5>
<p class="text-muted small">Fill in the form and our care team will get back to you shortly.</p>
<form action="#" method="post">
<div class="row g-3">
<div class="col-12 col-md-6"><label class="form-label">Full Name *</label><input type="text" class="form-control" required placeholder="Your Name"></div>
<div class="col-12 col-md-6"><label class="form-label">Phone No *</label><input type="tel" class="form-control" required placeholder="Your Phone"></div>
<div class="col-12"><label class="form-label">Email ID</label><input type="email" class="form-control" placeholder="you@example.com"></div>
<div class="col-12"><label class="form-label">Subject</label><input type="text" class="form-control" placeholder="How can we help?"></div>
<div class="col-12"><label class="form-label">Your Message</label><textarea class="form-control" rows="5" placeholder="Type your message here..."></textarea></div>
<div class="col-12"><button type="submit" class="btn w-100" style="background:linear-gradient(90deg,#FFC107,#D4AF37);color:#0B2B66;font-weight:800;border:0;">SEND MESSAGE</button></div>
</div>
</form>
</div>
</div>
<div class="col-12 col-lg-5">
<div class="side-card mb-4">
<h5>Hospital Hours</h5>
<p class="mb-1"><i class="bi bi-clock-fill" style="color:#D4AF37;"></i> Emergency &amp; Pharmacy: <strong>Open 24x7</strong></p>
<p class="mb-0"><i class="bi bi-calendar-check" style="color:#D4AF37;"></i> OPD Consultations: <strong>9:00 AM - 8:00 PM</strong></p>
</div>
<div class="side-card">
<h5>Our Location</h5>
<iframe src="https://maps.google.com/maps?q=Sikkim%20Plaza%2C%203rd%20Mile%20Sevoke%20Road%2C%20Siliguri&t=&z=15&ie=UTF8&iwloc=&output=embed" width="100%" height="300" style="border:0;border-radius:12px;" loading="lazy"></iframe>
</div>
</div>
</div>
</div>
</section>
"@

# ============= CAREER =============
New-Page -Rel 'career\index.html' -Title 'Careers at Samridhi Hospital Siliguri' -Desc 'Join the Samridhi Hospital Siliguri team - we are always looking for passionate healthcare professionals.' -Body @"
<div class="page-inner"><span class="page-wm"></span><div class="container"><h1>Career at Samridhi Hospital</h1><div class="crumb"><a href="index.html">Home</a> <i class="bi bi-chevron-right"></i> Career</div></div></div>
<section class="sec-pad">
<div class="container">
<div class="side-card text-center p-5">
<h5 class="mb-3"><i class="bi bi-briefcase" style="color:#D4AF37;"></i> Career</h5>
<p class="mb-0">Content will be uploaded soon.</p>
</div>
</div>
</section>
"@

# ============= PRIVACY =============
New-Page -Rel 'privacy-policy\index.html' -Title 'Privacy Policy - Samridhi Hospital Siliguri' -Desc 'Read the privacy policy of Samridhi Hospital Siliguri.' -Body @"
<div class="page-inner"><span class="page-wm"></span><div class="container"><h1>Privacy Policy</h1><div class="crumb"><a href="index.html">Home</a> <i class="bi bi-chevron-right"></i> Privacy Policy</div></div></div>
<section class="sec-pad"><div class="container"><div class="row"><div class="col-12 col-lg-8">$(ConvertTo-BlockHtml (Get-Txt 'privacy-policy'))</div><div class="col-12 col-lg-4">$(Get-Sidebar)</div></div></div></section>
"@

# ============= TESTIMONIALS / PATIENTS CORNER =============
$testimonialCards = @"
<div class="mb-4">
  <p class="mb-2">The excerpts below are selected from public Google reviews for Samridhi Multispeciality Hospital. Wording is unchanged except where an ellipsis indicates an excerpt.</p>
  <a href="$GOOGLE_REVIEW_URL" target="_blank" rel="noopener" class="btn btn3 btn-sm">Read all Google reviews</a>
</div>
<article class="side-card mb-3">
  <div class="d-flex align-items-center justify-content-between mb-2"><h4 class="h5 mb-0">Sima Sinha</h4><span class="text-warning fw-600" aria-label="5 out of 5 stars">★★★★★</span></div>
  <p class="mb-2">&ldquo;I am from Siliguri and I came to Samridhi Hospital with a serious lung-related problem. I could not afford the expensive treatment at a big corporate hospital, so I was worried about how I would manage my treatment. But at Samridhi Hospital, I received very good treatment at a much more affordable cost. The doctors were experienced, caring, and gave me proper attention. The entire staff supported me throughout my treatment. &hellip; Thank you to the entire Samridhi Hospital team for your care, humanity, and support.&rdquo;</p>
  <small class="text-muted">Public Google review</small>
</article>
<article class="side-card mb-3">
  <div class="d-flex align-items-center justify-content-between mb-2"><h4 class="h5 mb-0">Ayush Chhetri</h4><span class="text-warning fw-600" aria-label="5 out of 5 stars">★★★★★</span></div>
  <p class="mb-2">&ldquo;The hospital was very clean and well-organized, and I felt comfortable during my entire stay. I could see that everyone working there truly cared about the patients. Their hard work and dedication really stood out. I am thankful for the good treatment and support I received. It made a difficult time much easier to go through. Overall, I’m very happy with my experience and would definitely recommend this hospital to anyone who needs care. It’s a place where you feel safe, supported, and well taken care of.&rdquo;</p>
  <small class="text-muted">Public Google review</small>
</article>
<article class="side-card mb-3">
  <div class="d-flex align-items-center justify-content-between mb-2"><h4 class="h5 mb-0">Satyendra Kumar</h4><span class="text-warning fw-600" aria-label="5 out of 5 stars">★★★★★</span></div>
  <p class="mb-2">&ldquo;&hellip; After trying several places, we finally came to Samridhi Hospital. My brother was in a very serious condition and needed emergency care and ventilator support. We requested the Samridhi team, and they admitted him and immediately started treatment. The doctors and entire medical team worked with great dedication. The nursing staff continuously supported us, and throughout this difficult time, everyone treated us with humanity and compassion. Today, the happiest moment for our family is that my brother has recovered well and has gone home. &hellip; Thank you, Samridhi Hospital, for standing with our family when we needed help the most.&rdquo;</p>
  <small class="text-muted">Public Google review</small>
</article>
<article class="side-card mb-3">
  <div class="d-flex align-items-center justify-content-between mb-2"><h4 class="h5 mb-0">Ajeet Kumar</h4><span class="text-warning fw-600" aria-label="5 out of 5 stars">★★★★★</span></div>
  <p class="mb-2">&ldquo;&hellip; At Samridhi Hospital, the doctors immediately examined the patient and started the necessary treatment. The doctors explained the situation clearly and guided us throughout the treatment. The nursing staff and other hospital staff were also very supportive and caring. What impressed us most was the personal attention and dedication of the doctors. &hellip; Thankfully, the patient improved and we were able to return home with much more confidence and relief. &hellip; Very grateful to the entire team. Highly recommended for their care and dedication.&rdquo;</p>
  <small class="text-muted">Public Google review</small>
</article>
"@
New-Page -Rel 'testimonials\index.html' -Title 'Patient Testimonials - Samridhi Hospital Siliguri' -Desc 'Selected public Google reviews from patients of Samridhi Hospital Siliguri.' -Body @"
<div class="page-inner"><span class="page-wm"></span><div class="container"><h1>Patient Testimonials</h1><div class="crumb"><a href="index.html">Home</a> <i class="bi bi-chevron-right"></i> Testimonials</div></div></div>
<section class="sec-pad"><div class="container"><div class="row"><div class="col-12 col-lg-8">$testimonialCards</div><div class="col-12 col-lg-4">$(Get-Sidebar)</div></div></div></section>
"@

New-Page -Rel 'patients-corner\index.html' -Title "Patient's Corner - Samridhi Hospital Siliguri" -Desc "Useful health information and resources for patients at Samridhi Hospital Siliguri." -Body @"
<div class="page-inner"><span class="page-wm"></span><div class="container"><h1>Patient's Corner</h1><div class="crumb"><a href="index.html">Home</a> <i class="bi bi-chevron-right"></i> Patient's Corner</div></div></div>
<section class="sec-pad">
<div class="container">
<div class="row">
<div class="col-12">
<p>Samridhi Hospital is a popular name in the healthcare industry of Siliguri. We understand the importance of proper care and treatment towards patient health and therefore try to provide the best care solutions through the hands of industry experts. Although we offer dedicated and personalised services to every patient, there are a few information that need to be understood by the patients and their family during their medical journey with us.</p>
<h3 class="sec-title mt-4 mb-3">Rights of Patients</h3>
<p class="point"><i class="bi bi-check2-circle"></i> Receive adequate care regardless of gender, race, religion and source of payment.</p>
<p class="point"><i class="bi bi-check2-circle"></i> Demand complete information about diagnostic results, health condition and treatment risks.</p>
<p class="point"><i class="bi bi-check2-circle"></i> Be acknowledged before being transferred to another facility.</p>
<p class="point"><i class="bi bi-check2-circle"></i> Know the expected cost and risk associated with the treatment.</p>
<p class="point"><i class="bi bi-check2-circle"></i> Request a change of doctor for a second opinion.</p>
<p class="point"><i class="bi bi-check2-circle"></i> Be treated with respect for cultural and spiritual beliefs.</p>
<h3 class="sec-title mt-4 mb-3">Responsibilities of Patients</h3>
<p class="point"><i class="bi bi-check2-circle"></i> Providing genuine and authentic personal and medical information.</p>
<p class="point"><i class="bi bi-check2-circle"></i> Following the prescribed medications and treatment plan.</p>
<p class="point"><i class="bi bi-check2-circle"></i> Informing about any pain, discomfort or challenge after treatment.</p>
<p class="point"><i class="bi bi-check2-circle"></i> Sharing treatment effectiveness feedback with doctors and nursing staff.</p>
<p class="point"><i class="bi bi-check2-circle"></i> Following the rules and regulations of the hospital.</p>
<p class="point"><i class="bi bi-check2-circle"></i> Taking care of your belongings within the hospital premises.</p>
<h3 class="sec-title mt-4 mb-3">Hospital Facilities</h3>
<p class="point"><i class="bi bi-check2-circle"></i> Wide range of rooms for healthy recovery - economy beds, general beds, premium rooms and deluxe rooms.</p>
<p class="point"><i class="bi bi-check2-circle"></i> Every ward is equipped with fire safety alarms and sprinklers for emergencies.</p>
<p class="point"><i class="bi bi-check2-circle"></i> 24x7 emergency services to handle any kind of medical emergency.</p>
<p class="point"><i class="bi bi-check2-circle"></i> Medical claims and reimbursement facilities accepted (cashless services not offered).</p>
<p class="point"><i class="bi bi-check2-circle"></i> Parking facilities available within the hospital premises.</p>
<p class="point"><i class="bi bi-check2-circle"></i> 24x7 ambulance service at a minimal cost.</p>
<h3 class="sec-title mt-4 mb-3">General Guidelines</h3>
<p class="point"><i class="bi bi-check2-circle"></i> Visiting hours: 10:00 AM - 12:00 PM and 4:00 PM - 6:00 PM.</p>
<p class="point"><i class="bi bi-check2-circle"></i> Medical staff may ask visitors to leave the room during tests and treatments.</p>
<p class="point"><i class="bi bi-check2-circle"></i> To ensure patient safety, the number of visitors may be limited.</p>
<p class="point"><i class="bi bi-check2-circle"></i> Kindly maintain silence within the hospital premises.</p>
<p class="point"><i class="bi bi-check2-circle"></i> We follow a strict 'No Tipping' policy - please do not tip our staff.</p>
<p class="point"><i class="bi bi-check2-circle"></i> Entry without permission is prohibited except for medical staff.</p>
<p class="point mb-0"><i class="bi bi-check2-circle"></i> To prevent the spread of infection, please do not sit on the patient's bed.</p>
</div>
</div>
</div>
</section>
"@

# ============= RESOURCES / MEDIA =============
function New-EmptyState([string]$title,[string]$crumb,[string]$msg,[string]$rel,[string]$desc){
  New-Page -Rel $rel -Title ($title + ' - Samridhi Hospital Siliguri') -Desc $desc -Body @"
<div class="page-inner"><span class="page-wm"></span><div class="container"><h1>$title</h1><div class="crumb"><a href="index.html">Home</a> <i class="bi bi-chevron-right"></i> $crumb</div></div></div>
<section class="sec-pad"><div class="container"><div class="side-card text-center p-5"><h5 class="mb-2">$title</h5><p class="mb-0 text-muted">$msg</p></div></div></section>
"@
}
New-EmptyState 'Blog' 'Blog' 'Health articles and updates from our specialists will be published here soon.' 'blog\index.html' 'Latest health blogs and articles from Samridhi Hospital Siliguri.'
New-EmptyState 'Video Gallery' 'Videos' 'Informative health videos from Samridhi Hospital specialists are coming soon.' 'videos\index.html' 'Health and wellness videos from Samridhi Hospital Siliguri.'
New-EmptyState 'Infographics' 'Infographics' 'Health infographics will be uploaded here soon.' 'infographics\index.html' 'Health infographics from Samridhi Hospital Siliguri.'
New-EmptyState 'Events &amp; Updates' 'Events' 'News of health camps and community events at Samridhi Hospital Siliguri will be shared here.' 'events\index.html' 'Health camps and community events by Samridhi Hospital Siliguri.'
New-EmptyState 'Press Release' 'Press Release' 'Official press releases of Samridhi Hospital Siliguri will be available here.' 'press-release\index.html' 'Press releases from Samridhi Hospital Siliguri.'

# ============= SITEMAP =============
$sitemapEntries = @()
$sitemapEntries += '<li><a href="index.html">Home</a></li>'
$sitemapEntries += '<li><a href="about">About Us</a></li>'
$sitemapEntries += '<li><a href="departments">Departments</a></li>'
foreach($s in $DEPT_SLUGS){ $sitemapEntries += "<li><a href=""department/$s"">$($DEF_DISPLAY[$s])</a></li>" }
$sitemapEntries += '<li><a href="doctors">Doctors</a></li>'
$sitemapEntries += '<li><a href="appointment">Book Appointment</a></li>'
$sitemapEntries += '<li><a href="contact">Contact Us</a></li>'
$sitemapEntries += '<li><a href="facilities">Facilities</a></li>'
$sitemapEntries += '<li><a href="faq">FAQs</a></li>'
$sitemapEntries += '<li><a href="laboratory-services">Laboratory Services</a></li>'
$sitemapEntries += '<li><a href="diagnostic-services">Diagnostic Services</a></li>'
$DIAG | ForEach-Object { $sitemapEntries += "<li><a href=""diagnostic-services/$($_.slug)"">$($_.name)</a></li>" }
$sitemapEntries += '<li><a href="support-services">Support Services</a></li>'
$sitemapEntries += '<li><a href="career">Career</a></li>'
$sitemapEntries += '<li><a href="testimonials">Testimonials</a></li>'
$sitemapEntries += '<li><a href="patients-corner">Patients Corner</a></li>'
$sitemapEntries += '<li><a href="blog">Blog</a></li>'
$sitemapEntries += '<li><a href="nursing-home-siliguri">Nursing Home in Siliguri</a></li>'
$sitemapEntries += '<li><a href="orthopaedic-doctor-siliguri">Orthopaedic Doctor in Siliguri</a></li>'
$sitemapEntries += '<li><a href="general-surgery-in-siliguri">General Surgery in Siliguri</a></li>'
$sitemapEntries += '<li><a href="critical-care-siliguri">Critical Care in Siliguri</a></li>'
$sitemapEntries += '<li><a href="gynaecologist-in-siliguri">Gynaecologist in Siliguri</a></li>'
$sitemapEntries += '<li><a href="urologist-in-siliguri">Urologist in Siliguri</a></li>'
$sitemapEntries += '<li><a href="neurologist-in-siliguri">Neurologist in Siliguri</a></li>'
$sitemapEntries += '<li><a href="cardiologist-in-siliguri">Cardiologist in Siliguri</a></li>'
$sitemapEntries += '<li><a href="privacy-policy">Privacy Policy</a></li>'
New-Page -Rel 'sitemap\index.html' -Title 'Sitemap - Samridhi Hospital Siliguri' -Desc 'Complete sitemap of Samridhi Hospital Siliguri website.' -Body @"
<div class="page-inner"><span class="page-wm"></span><div class="container"><h1>Sitemap</h1><div class="crumb"><a href="index.html">Home</a> <i class="bi bi-chevron-right"></i> Sitemap</div></div></div>
<section class="sec-pad"><div class="container"><div class="side-card"><h5>All Pages</h5><ul class="mb-0" style="columns:2;gap:30px;">$($sitemapEntries -join '')</ul></div></div></section>
"@

# ============= SEO LANDING PAGES =============
$seoPages = @(
  @{rel='nursing-home-siliguri\index.html'; title='Nursing Home in Siliguri | Samridhi Hospital'; tx='nursing-home-siliguri'},
  @{rel='orthopaedic-doctor-siliguri\index.html'; title='Orthopaedic Doctor in Siliguri | Samridhi Hospital'; tx='orthopaedic-doctor-siliguri'},
  @{rel='general-surgery-in-siliguri\index.html'; title='General Surgery in Siliguri | Samridhi Hospital'; tx='general-surgery-in-siliguri'},
  @{rel='critical-care-siliguri\index.html'; title='Critical Care in Siliguri | Samridhi Hospital'; tx='critical-care-siliguri'},
  @{rel='gynaecologist-in-siliguri\index.html'; title='Gynaecologist in Siliguri | Samridhi Hospital'; tx='gynaecologist-in-siliguri'},
  @{rel='urologist-in-siliguri\index.html'; title='Urologist in Siliguri | Samridhi Hospital'; tx='urologist-in-siliguri'},
  @{rel='neurologist-in-siliguri\index.html'; title='Neurologist in Siliguri | Samridhi Hospital'; tx='neurologist-in-siliguri'},
  @{rel='cardiologist-in-siliguri\index.html'; title='Cardiologist in Siliguri | Samridhi Hospital'; tx='cardiologist-in-siliguri'}
)
foreach($p in $seoPages){
  New-Page -Rel $p.rel -Title $p.title -Desc ($p.title + ' - best healthcare services in Siliguri.') -Body @"
<div class="page-inner"><span class="page-wm"></span><div class="container"><h1>$($p.title)</h1><div class="crumb"><a href="index.html">Home</a> <i class="bi bi-chevron-right"></i> $($p.title)</div></div></div>
<section class="sec-pad"><div class="container"><div class="row"><div class="col-12 col-lg-8">$(ConvertTo-BlockHtml (Get-Txt $p.tx))</div><div class="col-12 col-lg-4">$(Get-Sidebar)</div></div></div></section>
"@
}

# ============= DEPARTMENT PAGES =============
foreach($s in $DEPT_SLUGS){
  New-Page -Rel ("department\$s\index.html") -Title ($DEF_DISPLAY[$s] + ' - Samridhi Hospital Siliguri') -Desc ('Best ' + ($DEF_DISPLAY[$s] -replace '&amp;','and') + ' specialists and treatment in Siliguri at Samridhi Hospital.') -Body (Get-DeptBody $DEF_DISPLAY[$s] $s) -Depth 2
}

# ============= SPECIALITY DOCTOR PAGES =============
foreach($s in $docDepts){
  $disp = $DEF_DISPLAY[$s]
  $doctorList = "<div class=""row"">$(Get-DocCards $s)</div>"
  New-Page -Rel ("doctor\$s\index.html") -Title ($disp + ' Doctors | Samridhi Hospital Siliguri') -Desc ('Meet our specialist ' + ($disp -replace '&amp;','and') + ' doctors at Samridhi Hospital Siliguri.') -Body @"
<div class="page-inner"><span class="page-wm"></span><div class="container"><h1>$disp Doctors</h1><div class="crumb"><a href="index.html">Home</a> <i class="bi bi-chevron-right"></i> <a href="doctors">Doctors</a> <i class="bi bi-chevron-right"></i> $disp</div></div></div>
<section class="sec-pad">
<div class="container">
<div class="sec-title text-center mb-5"><h2>Our <span class="grd-text">$disp</span> Specialists</h2><p>Comprehensive specialist care for patients across Siliguri and North Bengal.</p></div>
$doctorList
<div class="cta-band mt-5"><div class="row align-items-center"><div class="col-12 col-md-8"><h2>Need a consultation?</h2><p>Book an appointment with our $disp team today.</p></div><div class="col-12 col-md-4 text-md-end mt-3 mt-md-0"><a class="btn" style="background:linear-gradient(90deg,#FFC107,#D4AF37);color:#0B2B66;font-weight:800;" href="appointment">Book Appointment</a></div></div></div>
</div>
</section>
"@ -Depth 2
}

"`nGenerated all pages. Total:"
# ============= LEGACY 404 PAGES =============
$notFoundBody = @"
<div class="sec-pad"><div class="container py-lg-4 my-lg-5 text-center"><img src="images/404.png" alt="404" class="max mb-4 transition" width="200" height="72"><h1 class="h1 fw-600" style="color:#0B2B66;">Sorry, Page Not Found!</h1><p class="mb-3 font17">The page you are looking for might have been removed or does not exist.</p><div class="mt-lg-5"><a href="index.html" class="btn btn3 btn-md">Go to Homepage</a></div></div></div>
"@
New-Page -Rel '1729247656Dr.html' -Title 'Page Not Found | Samridhi Hospital Siliguri' -Desc 'The page you are looking for might have been removed or does not exist.' -Depth 0 -Body $notFoundBody
New-Page -Rel '17262072031705491171doctor.html' -Title 'Page Not Found | Samridhi Hospital Siliguri' -Desc 'The page you are looking for might have been removed or does not exist.' -Depth 0 -Body $notFoundBody
# ============= LEGACY HOMEPAGE DOCTOR / EVENT SLUGS =============
$homeHtml = [System.IO.File]::ReadAllText((Join-Path $root 'index.html'))
$drSlugs = @([regex]::Matches($homeHtml,'href="doctor/(dr-[^/"]+)(?:/index\.html)?"') | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique)
foreach($dr in $drSlugs){
  if($DOCTYPE | Where-Object { $_.slug -eq $dr }){ continue }
  if(Test-Path -LiteralPath (Join-Path $root ("doctor\$dr\index.html"))){ continue }
  $nice = ($dr -replace '^dr-','' -replace '-',' ') -replace '\b(\w)',{ param($x) $x.Value.ToUpper() }
  New-Page -Rel ("doctor\$dr\index.html") -Title "$nice | Samridhi Hospital Siliguri" -Desc "$nice, specialist consultant at Samridhi Hospital Siliguri." -Body @"
<div class="page-inner"><span class="page-wm"></span><div class="container"><h1>$nice</h1><div class="crumb"><a href="index.html">Home</a> <i class="bi bi-chevron-right"></i> <a href="doctors">Doctors</a> <i class="bi bi-chevron-right"></i> $nice</div></div></div>
<section class="sec-pad"><div class="container"><div class="row"><div class="col-12 col-lg-8"><div class="side-card text-center"><i class="bi bi-person-badge" style="font-size:52px;color:#D4AF37;"></i><h5 class="mt-3">$nice</h5><p class="text-muted">Specialist consultant at Samridhi Hospital, Siliguri. Full profile is being updated.</p><a class="btn mt-2" style="background:linear-gradient(90deg,#FFC107,#D4AF37);color:#0B2B66;font-weight:800;" href="appointment">Book Appointment</a></div></div><div class="col-12 col-lg-4">$(Get-Sidebar)</div></div></div></section>
"@ -Depth 2
}
foreach($doc in $DOCTYPE){
  $pdf = Join-Path $root ("doctor\$($doc.slug)\index.html")
  if(Test-Path -LiteralPath $pdf){ Remove-Item -LiteralPath $pdf -Force }
  New-Page -Rel ("doctor\$($doc.slug)\index.html") -Title "$($doc.name) | Samridhi Hospital Siliguri" -Desc "$($doc.about)" -Body @"
<div class="page-inner"><span class="page-wm"></span><div class="container"><h1>$($doc.name)</h1><div class="crumb"><a href="index.html">Home</a> <i class="bi bi-chevron-right"></i> <a href="doctors">Doctors</a> <i class="bi bi-chevron-right"></i> $($doc.name)</div></div></div>
$(Get-DoctorBody $doc)
"@ -Depth 2
}
$eSlugs = @([regex]::Matches($homeHtml,'href="e/([^"]+)"') | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique)
foreach($ev in $eSlugs){
  if(Test-Path -LiteralPath (Join-Path $root ("e\$ev\index.html"))){ continue }
  $niceEv = ($ev -replace '-',' ') -replace '\b(\w)',{ param($x) $x.Value.ToUpper() }
  New-Page -Rel ("e\$ev\index.html") -Title "$niceEv | Samridhi Hospital Siliguri" -Desc "$niceEv - news and updates from Samridhi Hospital Siliguri." -Body @"
<div class="page-inner"><span class="page-wm"></span><div class="container"><h1>$niceEv</h1><div class="crumb"><a href="index.html">Home</a> <i class="bi bi-chevron-right"></i> <a href="events">Events</a> <i class="bi bi-chevron-right"></i> $niceEv</div></div></div>
<section class="sec-pad"><div class="container"><div class="side-card text-center"><h5 class="mb-2">$niceEv</h5><p class="text-muted mb-0">Full story and photos will be published here soon.</p></div></div></section>
"@ -Depth 2
}
Get-ChildItem $root -Recurse -Filter *.html | Where-Object { $_.FullName -ne (Join-Path $root 'index.html') } | Measure-Object | Select-Object -ExpandProperty Count