unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls,
  SplitterEx;

type
  TSplitter = class(TSplitterEx); // magic! Now all standard TSplitters will get level-up :)

  TForm1 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Image1: TImage;
    Panel4: TPanel;
    Splitter2: TSplitter;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Splitter3: TSplitter;
    Panel8: TPanel;
    Panel9: TPanel;
    Splitter1: TSplitter;
    Image2: TImage;
    Panel10: TPanel;
    Splitter4: TSplitter;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Splitter5: TSplitter;
    Panel14: TPanel;
    Panel15: TPanel;
    Image3: TImage;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  Splitter1.SetImages(Image3, Image1);
  Splitter1.ToggleControl := Panel2;
  Splitter1.HotColor := clHotLight;

  Splitter2.SetImages(Image3, Image1);
  Splitter2.ToggleControl := Panel6;
  Splitter2.HotColor := clHotLight;

  Splitter5.SetImages(Image3, Image1);
  Splitter5.ToggleControl := Panel15;
  Splitter5.DenyDrag := True;
  Splitter5.HotColor := clHotLight;

  Splitter3.SetImages(Image2);
  Splitter3.ToggleControl := Panel8;
  Splitter3.HotColor := clHotLight;

  Splitter4.SetImages(Image2);
  Splitter4.ToggleControl := Panel12;
  Splitter4.HotColor := clHotLight;

end;

end.
