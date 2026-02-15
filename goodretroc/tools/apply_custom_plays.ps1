param(
  [string]$RetroBowlPath = "html5game/RetroBowl.js",
  [string]$JsonPath = "retro-custom-routes-plays.json"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Escape-Regex([string]$s) {
  return [Regex]::Escape($s)
}

function Replace-MarkerBlock {
  param(
    [string]$Text,
    [string]$BeginMarker,
    [string]$EndMarker,
    [string]$InnerText
  )
  $pattern = "(?s)(" + (Escape-Regex $BeginMarker) + ").*?(" + (Escape-Regex $EndMarker) + ")"
  $replacement = "$BeginMarker`r`n$InnerText`r`n$EndMarker"
  return [Regex]::Replace($Text, $pattern, [System.Text.RegularExpressions.MatchEvaluator]{ param($m) $replacement }, 1)
}

function JsQ([string]$s) {
  return '"' + ($s -replace '\\', '\\\\' -replace '"', '\"') + '"'
}

function Build-RouteCode($route) {
  $name = [string]$route.name
  $points = @()
  foreach ($p in @($route.points)) {
    $x = [int]$p.x
    $y = [int]$p.y
    $spd = if ($null -ne $p.speed) { [int]$p.speed } else { 100 }
    $points += "        { x: $x, y: $y, speed: $spd }"
  }
  if ($points.Count -eq 0) {
    $points += "        { x: 0, y: 0, speed: 100 }"
  }
  return @(
    "    {",
    "      pName: $(JsQ $name),",
    "      kind: 0,",
    "      closed: false,",
    "      precision: 1,",
    "      points: [",
    ($points -join ",`r`n"),
    "      ],",
    "    },"
  ) -join "`r`n"
}

function Build-PlayBlock($plays) {
  if ($plays.Count -eq 0) {
    return "      // No custom plays in JSON"
  }
  $out = @()
  foreach ($p in $plays) {
    $label = [string]$p.label
    if ([string]::IsNullOrWhiteSpace($label)) { continue }
    $out += "      if (yyGetBool(yyfequal(gmlpb_label_custom, $(JsQ $label)))) {"
    if (-not [string]::IsNullOrWhiteSpace([string]$p.p4)) { $out += "        if (yyGetBool(yyfequal(_inst.gmlposition, 4))) _inst.gmlmy_route_name = $(JsQ ([string]$p.p4));" }
    if (-not [string]::IsNullOrWhiteSpace([string]$p.p3)) { $out += "        if (yyGetBool(yyfequal(_inst.gmlposition, 3))) _inst.gmlmy_route_name = $(JsQ ([string]$p.p3));" }
    if (-not [string]::IsNullOrWhiteSpace([string]$p.p2)) { $out += "        if (yyGetBool(yyfequal(_inst.gmlposition, 2))) _inst.gmlmy_route_name = $(JsQ ([string]$p.p2));" }
    if (-not [string]::IsNullOrWhiteSpace([string]$p.p1)) { $out += "        if (yyGetBool(yyfequal(_inst.gmlposition, 1))) _inst.gmlmy_route_name = $(JsQ ([string]$p.p1));" }
    if (-not [string]::IsNullOrWhiteSpace([string]$p.p5)) {
      $out += "        if (yyGetBool(yyfequal(_inst.gmlposition, 5))) _inst.gmlmy_route_name = $(JsQ ([string]$p.p5));"
    }
    if (-not [string]::IsNullOrWhiteSpace([string]$p.p6)) { $out += "        if (yyGetBool(yyfequal(_inst.gmlposition, 6))) _inst.gmlmy_route_name = $(JsQ ([string]$p.p6));" }
    $out += "      }"
  }
  if ($out.Count -eq 0) {
    return "      // No custom plays in JSON"
  }
  return ($out -join "`r`n")
}

function Build-FormationBlock($plays) {
  if ($plays.Count -eq 0) {
    return "      // No custom formations in JSON"
  }
  $out = @()
  foreach ($p in $plays) {
    $label = [string]$p.label
    if ([string]::IsNullOrWhiteSpace($label)) { continue }
    $f = $p.formation
    if ($null -eq $f) {
      $f = @{
        p4 = @{x=0;y=-60}; p3 = @{x=0;y=-20}; p2 = @{x=0;y=30};
        p1 = @{x=-36;y=-20}; p5 = @{x=0;y=60}; p6 = @{x=0;y=10}
      }
    }
    $out += "      if (yyGetBool(yyfequal(gmlpb_label_form, $(JsQ $label)))) {"
    $out += "        if (yyGetBool(yyfequal(_inst.gmlposition, 4))) { _inst.x = yyfplus(yyInst(_inst, _other, YYASSET_REF(0x00000069)).gmlx_scrim, __yy_gml_errCheck(yyftime($([int]$f.p4.x), __yy_gml_errCheck(_inst.gmlfacing)))); _inst.y = yyfplus(yyInst(_inst, _other, YYASSET_REF(0x00000069)).gmly_scrim, $([int]$f.p4.y)); }"
    $out += "        if (yyGetBool(yyfequal(_inst.gmlposition, 3))) { _inst.x = yyfplus(yyInst(_inst, _other, YYASSET_REF(0x00000069)).gmlx_scrim, __yy_gml_errCheck(yyftime($([int]$f.p3.x), __yy_gml_errCheck(_inst.gmlfacing)))); _inst.y = yyfplus(yyInst(_inst, _other, YYASSET_REF(0x00000069)).gmly_scrim, $([int]$f.p3.y)); }"
    $out += "        if (yyGetBool(yyfequal(_inst.gmlposition, 2))) { _inst.x = yyfplus(yyInst(_inst, _other, YYASSET_REF(0x00000069)).gmlx_scrim, __yy_gml_errCheck(yyftime($([int]$f.p2.x), __yy_gml_errCheck(_inst.gmlfacing)))); _inst.y = yyfplus(yyInst(_inst, _other, YYASSET_REF(0x00000069)).gmly_scrim, $([int]$f.p2.y)); }"
    $out += "        if (yyGetBool(yyfequal(_inst.gmlposition, 1))) { _inst.x = yyfplus(yyInst(_inst, _other, YYASSET_REF(0x00000069)).gmlx_scrim, __yy_gml_errCheck(yyftime($([int]$f.p1.x), __yy_gml_errCheck(_inst.gmlfacing)))); _inst.y = yyfplus(yyInst(_inst, _other, YYASSET_REF(0x00000069)).gmly_scrim, $([int]$f.p1.y)); }"
    $out += "        if (yyGetBool(yyfequal(_inst.gmlposition, 5))) { _inst.x = yyfplus(yyInst(_inst, _other, YYASSET_REF(0x00000069)).gmlx_scrim, __yy_gml_errCheck(yyftime($([int]$f.p5.x), __yy_gml_errCheck(_inst.gmlfacing)))); _inst.y = yyfplus(yyInst(_inst, _other, YYASSET_REF(0x00000069)).gmly_scrim, $([int]$f.p5.y)); }"
    $out += "        if (yyGetBool(yyfequal(_inst.gmlposition, 6))) { _inst.x = yyfplus(yyInst(_inst, _other, YYASSET_REF(0x00000069)).gmlx_scrim, __yy_gml_errCheck(yyftime($([int]$f.p6.x), __yy_gml_errCheck(_inst.gmlfacing)))); _inst.y = yyfplus(yyInst(_inst, _other, YYASSET_REF(0x00000069)).gmly_scrim, $([int]$f.p6.y)); }"
    $out += "      }"
  }
  if ($out.Count -eq 0) {
    return "      // No custom formations in JSON"
  }
  return ($out -join "`r`n")
}

if (!(Test-Path $RetroBowlPath)) { throw "RetroBowl.js not found: $RetroBowlPath" }
if (!(Test-Path $JsonPath)) { throw "JSON file not found: $JsonPath" }

$obj = Get-Content -Raw -Path $JsonPath | ConvertFrom-Json
$routes = @($obj.routes)
$plays = @($obj.plays)

$text = Get-Content -Raw -Path $RetroBowlPath

$pathCode = if ($routes.Count -gt 0) { ($routes | ForEach-Object { Build-RouteCode $_ }) -join "`r`n`r`n" } else { "    // No custom routes in JSON" }
$playCode = Build-PlayBlock $plays
$formCode = Build-FormationBlock $plays

$slots = @("RUN", "SHORT", "PASS", "DEEP")
foreach ($p in $plays) {
  if ($null -eq $p.slot -or [string]::IsNullOrWhiteSpace([string]$p.label)) { continue }
  $slot = [int]$p.slot
  if ($slot -ge 0 -and $slot -le 3) { $slots[$slot] = [string]$p.label }
}
$labelCode = @(
  "_inst.gmlplaybook_labels[__yy_gml_array_check_index_set(0)] = $(JsQ $slots[0]);",
  "_inst.gmlplaybook_labels[__yy_gml_array_check_index_set(1)] = $(JsQ $slots[1]);",
  "_inst.gmlplaybook_labels[__yy_gml_array_check_index_set(2)] = $(JsQ $slots[2]);",
  "_inst.gmlplaybook_labels[__yy_gml_array_check_index_set(3)] = $(JsQ $slots[3]);"
) -join "`r`n"

$text = Replace-MarkerBlock -Text $text -BeginMarker "// RBCUSTOM_PATHS_BEGIN" -EndMarker "// RBCUSTOM_PATHS_END" -InnerText $pathCode
$text = Replace-MarkerBlock -Text $text -BeginMarker "// RBCUSTOM_LABELS_BEGIN" -EndMarker "// RBCUSTOM_LABELS_END" -InnerText $labelCode
$text = Replace-MarkerBlock -Text $text -BeginMarker "// RBCUSTOM_PLAYS_BEGIN" -EndMarker "// RBCUSTOM_PLAYS_END" -InnerText $playCode
$text = Replace-MarkerBlock -Text $text -BeginMarker "// RBCUSTOM_FORMATION_BEGIN" -EndMarker "// RBCUSTOM_FORMATION_END" -InnerText $formCode

Set-Content -Path $RetroBowlPath -Value $text -NoNewline
Write-Host "Applied custom plays from $JsonPath to $RetroBowlPath"
