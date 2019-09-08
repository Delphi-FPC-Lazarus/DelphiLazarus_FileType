{
  Util Unit für Dateierweiterungen

  08/2012 XE2 kompatibel
  02/2016 XE10 x64 Test

  xx/xxxx FPC Ubuntu

  --------------------------------------------------------------------
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.

  THE SOFTWARE IS PROVIDED "AS IS" AND WITHOUT WARRANTY

  Author: Peter Lorenz
  Is that code useful for you? Donate!
  Paypal webmaster@peter-ebe.de
  --------------------------------------------------------------------

}

{$I ..\share_settings.inc}
unit filetype_unit;

interface

uses
{$IFNDEF UNIX}Windows, {$ENDIF}
{$IFDEF FPC}LCLIntf, LCLType, LMessages, {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

{ -------------------------------------------------------------------- }

{ Preset }
procedure filetypespreset(zusatz_audio, zusatz_video, zusatz_image: string);

{ Variablen für die interne Verwendung
  Belegt erst im Preset damit änder und zurückstellbar
}
var
  f_onlywav: string = '';

  f_onlymp2: string = '';
  f_onlymp3: string = '';
  f_onlyogg: string = '';
  f_onlyaac: string = '';
  f_onlyaiff: string = '';
  f_onlyflac: string = '';
  f_onlymid: string = '';
  f_onlywma: string = '';
  f_onlywmv: string = '';

  f_onlysynthesizer: string = '';

  f_onlycue: string = '';

  f_allaudio: string = '';
  f_allvideo: string = '';
  f_allimage: string = '';

function FileExtIn(const filename: string; const f_scanext: string): boolean;
function FileIsImage(const filename: string): boolean;
function FileIsAudioVideo(const filename: string): boolean;

{ -------------------------------------------------------------------- }

implementation

procedure filetypespreset(zusatz_audio, zusatz_video, zusatz_image: string);
begin
  { Dateitypdefinitionen: '.' und ',' nicht vergessen (auch am Ende! }

  { Typen mit spezieller Behandlung }
  f_onlywav := '.WAV,'; { kein Tag }

  f_onlymp2 := '.MP2,'; { id3/id3v2 }
  f_onlymp3 := '.MP3,.MP3(D),'; { id3/id3v2 }
  f_onlyaac := '.AAC,.M4A,'; { id3/id3v2 }
  f_onlyaiff := '.AIFF,'; { id3/id3v2 }
  f_onlyogg := '.OGG,'; { vorbis comment }
  f_onlyflac := '.FLAC,'; { vorbis comment }
  f_onlywma := '.WMA,'; { wma/wmv comment }
  f_onlywmv := '.WMV,'; { wma/wmv comment }
  f_onlymid := '.MID,'; { midi comment }

  f_onlysynthesizer := '.MID,.MIDI,.RMI,.KAR,.MIZ,'; { Synthetisierte Formate }
  // Trackerformate nicht (.MOD,.MDZ,.SYX,.S3Z,.STZ,.MOD,.IT,.ITZ,.S3M,.XM,.XMZ,.MTM,.ULT,.669,.FAR,.AMF,.OKT,)

  f_onlycue := '.CUE,'; { cue dateien }

  { Audio/Video Typen (Vorgabe) }
  f_allaudio :=
    '.MP3,.MP3(D),.MP2,.MP1,.AAC,.APL,.WMA,.MID,.MIDI,.RMI,.KAR,.MIZ,.MOD,.MDZ,'
    + '.NST,.STM,.STZ,.S3M,.S3Z,.IT,.ITZ,.XM,.XMZ,.MTM,.ULT,.669,.FAR,.AMF,.OKT,'
    + '.PTM,.OGG,.MP4,.M4A,.M4B,.M4P,.CDA,.WAV,.VOC,.AU,.SND,.AIF,.AIFF,.NSA,.AVR,.CAF,.HTK,'
    + '.IFF,.MAT,.PAF,.PVF,.RAW,.SD2,.SDS,.SF,.W64,.FLAC,.OPOS,';

  f_allvideo :=
    '.NSV,.MPG,.MPEG,.M2V,.AVI,.ASF,.WMV,.DIVX,.VIDX,.MKV,.MP4,M4V,.MOV,.FLV,.WEBM,';

  f_allimage := '.GIF,.PNG,.JPG,.JPEG,.BMP,.ICO,.EMF,.WMF,.TIF,.TIFF';

  { zusätzliche Audio Typen (Benutzerdefiniert) }
  zusatz_audio := uppercase(trim(zusatz_audio));
  if length(zusatz_audio) > 0 then
  begin
    if zusatz_audio[length(zusatz_audio)] <> ',' then
      zusatz_audio := zusatz_audio + ',';
    f_allaudio := f_allaudio + zusatz_audio;
  end;

  { zusätzliche Video Typen (Benutzerdefiniert) }
  zusatz_video := uppercase(trim(zusatz_video));
  if length(zusatz_video) > 0 then
  begin
    if zusatz_video[length(zusatz_video)] <> ',' then
      zusatz_video := zusatz_video + ',';
    f_allvideo := f_allvideo + zusatz_video;
  end;

  { zusätzliche image Typen (Benutzerdefiniert) }
  zusatz_image := uppercase(trim(zusatz_image));
  if length(zusatz_image) > 0 then
  begin
    if zusatz_image[length(zusatz_image)] <> ',' then
      zusatz_image := zusatz_image + ',';
    f_allimage := f_allimage + zusatz_image;
  end;

end;

function FileExtIn(const filename: string; const f_scanext: string): boolean;
var
  ext: string;
begin
  Result := false;

  if (length(f_scanext) < 1) then
  begin
    Result := true;
    exit;
  end;

  { erweiterung rausholen }
  ext := strrscan(pchar(filename), '.');
  if length(ext) > 0 then
  begin
    if ext[1] = '.' then
      ext[1] := ' ';
    ext := '.' + uppercase(trim(ext)) + ',';
    { '.' und ',' nicht vergessen damit nicht ausversehen falsche Dateien gefunden werden (z.B. ".3" oder ".mp"! }
  end;

  if (length(ext) > 0) and (strpos(pchar(f_scanext), pchar(ext)) <> nil) then
  begin
    Result := true;
  end;

end;

function FileIsImage(const filename: string): boolean;
begin
  Result := FileExtIn(filename, f_allimage);
end;

function FileIsAudioVideo(const filename: string): boolean;
begin
  Result := FileExtIn(filename, f_allaudio) or FileExtIn(filename, f_allvideo);
end;

initialization

{
  Aufruf filetypepreset() ohne zusätzliche Dateitypen.
  Aufruf kann von Anwendung mit zusätzlichen Dateitypen wiederholt werden
  Zusätzlich kann über den erneuten Aufruf der Default wiederhergestellt werden.
}
filetypespreset('', '', '');

finalization

{ nix }

end.
