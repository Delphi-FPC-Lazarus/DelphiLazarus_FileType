unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfrmMain = class(TForm)
    btnAddTypes: TButton;
    btnTestTypes2: TButton;
    btnTestTypes1: TButton;
    procedure btnAddTypesClick(Sender: TObject);
    procedure btnTestTypes2Click(Sender: TObject);
    procedure btnTestTypes1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses filetype_unit;

procedure TfrmMain.btnAddTypesClick(Sender: TObject);
begin
 filetypespreset('.TTA', '.TTV', '');
end;

procedure TfrmMain.btnTestTypes1Click(Sender: TObject);
begin
 if FileExtIn('TEST.mp3', f_allaudio) then
  showmessage('mp3 -> Audio');
 if FileExtIn('TEST.mp4', f_allvideo) then
  showmessage('mp4 -> Video');
end;

procedure TfrmMain.btnTestTypes2Click(Sender: TObject);
begin
 if FileExtIn('TEST.TTA', f_allaudio) then
  showmessage('TTA -> Audio');
 if FileExtIn('TEST.TTA', f_allvideo) then
  showmessage('TTA -> Video');

 if FileExtIn('TEST.TTV', f_allaudio) then
  showmessage('TTV -> Audio');
 if FileExtIn('TEST.TTV', f_allvideo) then
  showmessage('TTV -> Video');

end;

end.
