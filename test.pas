program gra;
uses crt,allegro;
type  pla= array[-1..10,-1..10] of integer;
var tabli:array[-1..10,-1..10]of integer;
  tabli2:array[-1..10,-1..10]of integer;
  al:array[-1..10,-1..10]of integer;
  czysc,tlo,trafiony,plusk,statek,dol,ludek,ludek2:^al_BITMAP;
function licz:integer;
var i,j:integer;
begin
  al_clear_keybuf;
  j:=al_readkey;
  i:=(j >> 8);
  j:=i-27;
  writeln(j);
  licz:=j;
end;
procedure pisz(n:string;x,y,k:integer);
var z:integer;
begin
     if k=1 then z:=26 else z:=90;
     dol:=al_load_bitmap('dol.bmp',nil);
     al_textout_ex( dol, al_font, n, z, 20, -1, - 1 );
     al_blit( dol, al_screen, 0, 0, x, y, dol^.w, dol^.h );

end;
procedure okienka;
begin
     pisz(' ',500,500,1);
     pisz(' ',250,450,1);
     pisz(' ',0,500,1);
     pisz(' ',250,550,1);
end;
function obczaj(a:integer):boolean;
begin
     if a>=0 then begin
     if a<=9 then obczaj:=false end
     else obczaj:=true;
end;
procedure odkryj(t:integer);
var i,j,x:integer;
    tab:pla;
begin
     if t=1 then begin
     tab:=tabli; x:=57 end
     else begin
     tab:=tabli2; x:=457; end;
     for i:=0 to 9 do
         for j:=0 to 9 do begin
             if tab[i][j]=1 then
                al_masked_blit( plusk, al_screen, 0, 0, x+25+(j*25), 125+(i*25), 25,25 );
             if tab[i][j]=3 then
                al_masked_blit( trafiony, al_screen, 0, 0, x+25+(j*25), 125+(i*25), 25,25 );
             end;
end;
procedure rysuj(t:integer);
var i,j,x:integer;
  tab:pla;
begin
     if t=1 then begin
     tab:=tabli end
     else begin
         tab:=tabli2; end;
     if t=1 then x:=57
     else x:=457;
     for i:=0 to 9 do
         for j:=0 to 9 do begin
             if tab[i][j]=2 then
                al_masked_blit( statek, al_screen, 0, 0, x+25+(j*25), 125+(i*25), 25,25 );
              if tab[i][j]=1 then
                al_masked_blit( plusk, al_screen, 0, 0, x+25+(j*25), 125+(i*25), 25,25 );
               if tab[i][j]=3 then
                al_masked_blit( trafiony, al_screen, 0, 0, x+25+(j*25), 125+(i*25), 25,25 );
               end;
     {if t=1 then
        al_blit(ludek,al_screen,0,0,57,100,ludek^.w, ludek^.h)
     else
         al_blit(ludek2,al_screen,0,0,457,100,ludek2^.w, ludek2^.h);}
end;
procedure rozloz(var tab:pla;a,b,w:integer;k:char);
var i:integer;
begin
      if k='l' then
        for i:=0 to w-1 do
            tab[a][b-i]:=2;
      if k='g' then
         for i:=0 to w-1 do
             tab[a-i][b]:=2;
      if k='r' then
         for i:=0 to w-1 do
             tab[a][b+i]:=2;
      if k='d' then
         for i:=0 to w-1 do
             tab[a+i][b]:=2;
end;
function sprawdz(tab:pla;a,b,o:integer;k:char):integer;
var i,j:integer;
begin
         j:=0;
         if k='l' then begin
         for i:=-1 to o+1 do begin
             if tab[a][b-i]=2 then begin j:=1;  break; end;
             if tab[a+1][b-i]=2 then begin j:=1;  break; end;
             if tab[a-1][b-i]=2 then begin j:=1;  break; end;
                end;
             end;
         if k='r' then begin
            for i:=-1 to o+1 do begin
                if tab[a][b+i]=2 then begin j:=1; break; end;
                if tab[a+1][b+i]=2 then begin j:=1; break; end;
                if tab[a-1][b+i]=2 then begin j:=1; break; end;
                end;
            end;
         if k='g' then begin
            for i:=-1 to o+1 do begin
             if tab[a-i][b]=2 then begin j:=1; break; end;
             if tab[a-i][b+1]=2 then begin j:=1; break; end;
             if tab[a-i][b-1]=2 then begin j:=1; break; end;
             end;
         end;
         if k='d' then begin
            for i:=-1 to o+1 do begin
                if tab[a+i][b]=2 then begin j:=1; break; end;
                if tab[a+i][b-1]=2 then begin j:=1; break; end;
                if tab[a+i][b+1]=2 then begin j:=1; break; end;
                end;
            end;
         if k='o' then begin
         if tab[a][b-1]=2 then begin j:=1;  end;
         if tab[a][b+1]=2 then begin j:=1;  end;
         if tab[a+1][b]=2 then begin j:=1;  end;
         if tab[a-1][b]=2 then begin j:=1;  end;
         if tab[a-1][b-1]=2 then begin j:=1;  end;
         if tab[a+1][b+1]=2 then begin j:=1;  end;
         if tab[a+1][b-1]=2 then begin j:=1;  end;
         if tab[a-1][b+1]=2 then begin j:=1;  end;
         end;
   if j=1 then sprawdz:=1
   else sprawdz:=0;
end;
procedure polozeniea(o:integer;var tab:pla;t:integer);
label fail,crossroad;
var a,b,c,d:integer;
begin
   randomize;
   fail:
   a:=random(10);
   b:=random(10);
   if sprawdz(tab,a,b,0,'o')=1 then goto fail;
   c:=random(3);
   d:=0;
   crossroad:
   d:=d+1;
   case c of
   0: begin
       if a-o<0 then begin
          if d=4 then goto fail
          else goto crossroad;
       end;
       if sprawdz(tab,a,b,o,'g')=1 then  begin
          if d=4 then goto fail
          else goto crossroad;
       end else
           rozloz(tab,a,b,o,'g');
       end;
   1: begin
       if a+o>9 then begin
          if d=4 then goto fail
          else goto crossroad;
       end;
       if sprawdz(tab,a,b,o,'d')=1 then
       begin
          if d=4 then goto fail
          else goto crossroad;
       end;
       rozloz(tab,a,b,o,'d');
   end;
   2:  begin
            if b-o<0 then
            begin
               if d=4 then goto fail
               else goto crossroad;
            end;
            if sprawdz(tab,a,b,o,'l')=1 then begin
               if d=4 then goto fail
               else goto crossroad;
            end;
            rozloz(tab,a,b,o,'l');
   end;
   3:       begin
            if b+o>9 then begin
               if d=4 then goto fail
               else goto crossroad;
            end;
            if sprawdz(tab,a,b,o,'r')=1 then begin
               if d=4 then goto fail
               else goto crossroad;
            end;
            rozloz(tab,a,b,o,'r');
            end;
   end;
   rysuj(t);
end;
procedure polozenie(o:integer;var tab:pla;t:integer);
var a,b:integer;
label crossroad,fail;
begin
     fail:
      a:=-1;b:=-1;
      while(obczaj(a)) do begin
          pisz('Podaj pierwsza wspolrzedna',0,500,1);
          a:=licz;
          if  obczaj(a) then
          pisz('Bledna wspolrzedna',500,500,1);
      end;
      pisz('  ',500,500,1);
      while(obczaj(b)) do begin
          pisz('Podaj druga wspolrzedna',0,500,1);
          b:=licz;
          if  obczaj(b) then
              pisz('Bledna wspolrzedna',500,500,1);
      end;
      pisz('  ',500,500,1);
      if sprawdz(tab,a,b,0,'o')=1 then begin
         pisz('Miejsce zajete',500,500,1);
         goto fail;
      end;
      pisz('  ',500,500,1);
      al_clear_keybuf;
      while not(al_key[al_key_up]or al_key[al_key_down] or al_key[al_key_right]or al_key[al_key_left]or al_key[al_key_del]) do begin
          crossroad:
          pisz('Podaj kierunek',0,500,1);
          al_readkey;
          if not(al_key[al_key_up]or al_key[al_key_down] or al_key[al_key_right]or al_key[al_key_left]or al_key[al_key_del]) then
             pisz('To nie kierunek',500,500,1);
      end;
      pisz(' ',0,500,1);
      if al_key[al_key_del] then begin
         pisz(' ',0,500,1);
         pisz('Powtarzam wybor wspolrzendych',500,500,1);
         goto fail;
      end;
      if (al_key[al_key_up]) then begin
         if a-o<0 then begin pisz('Bledny kierunek',500,500,1);
         goto crossroad;
         end;
         if sprawdz(tab,a,b,o,'g')=1 then begin
            pisz('Bledny kierunek',500,500,1);
            goto crossroad;
         end else
         rozloz(tab,a,b,o,'g');
      end;
      if (al_key[al_key_down])then begin
                                   if a+o>9 then begin
                                      pisz('Bledny kierunek',500,500,1);
                                      goto crossroad;
                                   end;
                                   if sprawdz(tab,a,b,o,'d')=1 then begin
                                      pisz('Bledny kierunek',500,500,1);
                                      goto crossroad;
                                   end;
                                   rozloz(tab,a,b,o,'d');
      end;
      if (al_key[al_key_left])then  begin
                                   if b-o<0 then begin
                                      pisz('Bledny kierunek',500,500,1);
                                      goto crossroad;
                                   end;
                                   if sprawdz(tab,a,b,o,'l')=1 then begin
                                      pisz('Bledny kierunek',500,500,1);
                                      goto crossroad;
                                   end;
                                   rozloz(tab,a,b,o,'l');
      end;
      if (al_key[al_key_right])then  begin
                                   if b+o>9 then begin
                                      pisz('Bledny kierunek',500,500,1);
                                      goto crossroad;
                                   end;
                                   if sprawdz(tab,a,b,o,'r')=1 then begin
                                      pisz('Bledny kierunek',500,500,1);
                                      goto crossroad;
                                   end;
                                   rozloz(tab,a,b,o,'r');
      end;
rysuj(t);
end;
procedure rozmiesc(var tab:pla;t:integer);
var i:integer;
begin
     pisz('  ',500,500,1);
     pisz('Rozmiescczenie czteromasztowca',250,550,1);
     polozenie(4,tab,t);
     pisz('Rozmiescczenie trojmasztowcow',250,550,1);
     for i:=1 to 2 do
         polozenie(3,tab,t);
     pisz('Rozmiescczenie dwumasztowcow',250,550,1);
      for i:=1 to 3 do
          polozenie(2,tab,t);
     pisz('Rozmiesczenie jednomasztowcow',250,550,1);
     for i:=1 to 4 do
         polozenie(1,tab,t);
end;
procedure rozmiesca(var tab:pla;t:integer);
var i:integer;
begin
      polozeniea(4,tab,t);
      for i:=1 to 2 do
          polozeniea(3,tab,t);
      for i:=1 to 3 do
          polozeniea(2,tab,t);
      for i:=1 to 4 do
          polozeniea(1,tab,t);
end;
function strzelaj(var tab:pla):integer;
label fail;
  var a,b:integer;
begin
   fail:
   a:=-1;b:=-1;
   while(obczaj(a)) do begin
       pisz('Podaj pierwsza wspolrzedna',0,500,1);
       a:=licz;
       if  obczaj(a) then
           pisz('Bledna wspolrzedna',500,500,1);
   end;
   pisz('  ',500,500,1);
   while(obczaj(b)) do begin
       pisz('Podaj druga wspolrzedna',0,500,1);
       b:=licz;
       if  obczaj(b) then
           pisz('Bledna wspolrzedna',500,500,1);
   end;
   pisz('  ',500,500,1);
   if tab[a][b]=1 then begin
      pisz('Zdublowanie. Powtarzam ruch',500,500,1);
      goto fail;
   end;
   if tab[a][b]=3 then begin
      pisz('Zdublowanie. Powtarzam ruch',500,500,1);
      goto fail;
   end;
   if tab[a][b]=0 then begin
      pisz('Pudlo',500,500,1);
      tab[a][b]:=1;
      strzelaj:=0;
   end;
   if tab[a][b]=2 then begin
   pisz('Trafiony',500,500,1);
   tab[a][b]:=3;
   strzelaj:=1;
   end;
end;
procedure dwoch;
var x,y:integer;
  label wyjscie;
begin
   x:=20;y:=20;
   al_blit(czysc,al_screen,0,0,57,100,ludek^.w, ludek^.h);
   al_blit(czysc,al_screen,0,0,457,100,ludek^.w, ludek^.h);
   pisz('Plansza gracza 1',42,50,2);
   pisz('Plansza gracza 2',442,50,2);
   okienka;
   pisz('Rozmiescza gracz pierwszy',250,450,1);
   pisz('Autmoat?(T/N)',500,500,1);
   while not(al_key[al_key_T]or al_key[al_key_N]or al_key[al_key_esc]) do al_readkey;
   if al_key[al_key_T] then rozmiesca(tabli,1)
   else if al_key[al_key_N] then rozmiesc(tabli,1)
   else goto wyjscie;
   pisz('Gotowy?',500,500,1);
   al_readkey;
   al_blit(czysc,al_screen,0,0,57,100,ludek^.w, ludek^.h);
   pisz('Rozmiescza gracz drugi',250,450,1);
   al_clear_keybuf;
   pisz('Autmoat?(T/N)',500,500,1);
   while not(al_key[al_key_T]or al_key[al_key_N]or al_key[al_key_esc]) do al_readkey;
   if al_key[al_key_T] then rozmiesca(tabli2,2)
   else if al_key[al_key_N] then rozmiesc(tabli2,2)
   else goto wyjscie;
   pisz('Gotowy?',500,500,1);
   al_readkey;
   al_blit(czysc,al_screen,0,0,457,100,ludek^.w, ludek^.h);
   repeat
         pisz('Strzela gracz pierwszy',250,450,1);
         pisz('Gotowy?',500,500,1);
         al_readkey;
         if al_key[al_key_esc] then goto wyjscie;
         okienka;
         if strzelaj(tabli2)=1 then begin
            y:=y-1;
            if y=0 then break;
         end;
         odkryj(2);
         pisz('Strzela gracz drugi',250,450,1);
         pisz('Gotowy?',500,500,1);
         al_readkey;
         if al_key[al_key_esc] then goto wyjscie;
         okienka;
         if strzelaj(tabli)=1 then begin
            x:=x-1;
            if x=0 then break;
         end;
         odkryj(1);
   until false;
   rysuj(1);
   rysuj(2);
   okienka;
   if x=0 then pisz('Wygral gracz drugi',250,450,1);
   if y=0 then pisz('Wygral gracz pierwszy',250,450,1);
   al_readkey;
   wyjscie:
end;
procedure otoczenie(x,y,a,b:integer);
begin
     al[x-1][y-1]:=al[x-1][y-1]+a;
     al[x+1][y+1]:=al[x+1][y+1]+a;
     al[x-1][y+1]:=al[x-1][y+1]+a;
     al[x+1][y-1]:=al[x+1][y-1]+a;
     al[x+1][y]:=al[x+1][y]+b;
     al[x-1][y]:=al[x-1][y]+b;
     al[x][y-1]:=al[x][y-1]+b;
     al[x][y+1]:=al[x][y+1]+b;

end;
function ruchk:integer;
var i,j,max,x,y:integer;
label fail;
begin
max:=0;
for i:=0 to 9 do
    for j:=0 to 9 do begin
        if tabli[i][j]=1 then al[i][j]:=-1000;
        if tabli[i][j]=3 then al[i][j]:=-1000;
        if max<al[i][j] then begin
           max:=al[i][j];
           x:=i; y:=j;
        end;
    end;
if max<40 then begin
   fail:
   x:=random(10); y:=random(10);
   if tabli[x][y]=1 then goto fail;
   if tabli[x][y]=3 then goto fail;
   if al[x][y]<0 then goto fail;
end;
if tabli[x][y]=2 then begin
    otoczenie(x,y,-1000,120);
    tabli[x][y]:=3;
    ruchk:=1;
end;
if tabli[x][y]=0 then begin
    otoczenie(x,y,10,10);
    tabli[x][y]:=1;
    ruchk:=0;
end;
end;
procedure nowosc(var tab:pla);
var i,j:integer;
begin
     for i:=-1 to 10 do
         for j:=-1 to 10 do
             tab[i][j]:=0;
end;
procedure komputer;
var x,y:integer;
  label wyjscie;
begin
     al_blit(ludek,al_screen,0,0,57,100,ludek^.w, ludek^.h);
     al_blit(ludek2,al_screen,0,0,457,100,ludek2^.w, ludek2^.h);
     x:=20;y:=20;
     pisz('Plansza gracza',42,50,2);
     pisz('Plansza komputera',442,50,2);
     okienka;
     pisz('Rozmiescza gracz pierwszy',250,450,1);
     pisz('Autmoat?(T/N)',500,500,1);
     while not(al_key[al_key_T]or al_key[al_key_N]or al_key[al_key_esc]) do al_readkey;
     if al_key[al_key_T] then rozmiesca(tabli,1)
     else if al_key[al_key_N] then rozmiesc(tabli,1)
     else goto wyjscie;
     pisz('Gotowy?',500,500,1);
     al_readkey;
     if al_key[al_key_esc] then goto wyjscie;
     okienka;
     rozmiesca(tabli2,2);
     al_blit(czysc,al_screen,0,0,457,100,ludek^.w, ludek^.h);
     repeat
           pisz('Twoj ruch',250,450,1);
           pisz('Gotowy?',500,500,1);
           al_readkey;
           if al_key[al_key_esc] then goto wyjscie;
           pisz(' ',500,500,1);
           if strzelaj(tabli2)=1 then begin
              y:=y-1;
              if y=0 then break;
           end;
           odkryj(2);
           if ruchk=1 then begin
              x:=x-1;
              if x=0 then break;
           end;
           rysuj(1);
     until false;
     rysuj(1);
     rysuj(2);
     okienka;
     if x=0 then pisz('Wygral komputer',250,450,1);
     if y=0 then pisz('Wygrales',250,450,1);
     al_readkey;
     wyjscie:
end;

procedure init;
begin
     al_init();
     al_install_keyboard();
     al_set_color_depth(16);
     al_set_gfx_mode(al_GFX_AUTODETECT,800,600,0,0);
     al_install_sound( al_DIGI_AUTODETECT, al_MIDI_AUTODETECT);
     al_set_volume( 255, 255 );
     al_clear_to_color(al_screen,al_makecol(128,128,128));
     ludek:=al_load_bitmap('mojatablica.bmp',nil);
     if ludek=nil then  al_message('Nie wczytano planszy');
     ludek2:=al_load_bitmap('mojatablica.bmp',nil);
     if ludek2=nil then  al_message('Nie wczytano plansz');
     dol:=al_load_bitmap('dol.bmp',nil);
     if dol=nil then  al_message('Nie wczytano okna');
     statek:=al_load_bitmap('statek.bmp',nil);
     if statek=nil then  al_message('Nie wczytano statkow');
     plusk:=al_load_bitmap('plusk.bmp',nil);
     if plusk=nil then  al_message('Nie wczytano pudla');
     trafiony:=al_load_bitmap('trafiony.bmp',nil);
     if trafiony=nil then  al_message('Nie wczytano trafienia');
     tlo:=al_load_bitmap('tlo.bmp',nil);
     if tlo=nil then  al_message('Nie wczytano tla');
     czysc:=al_load_bitmap('mojatablica.bmp',nil);
     if czysc=nil then  al_message('Nie wczytano okna czysciciela');
     end;
procedure stworz;
begin
     al_blit(ludek,al_screen,0,0,57,100,ludek^.w, ludek^.h);
     al_blit(ludek2,al_screen,0,0,457,100,ludek^.w, ludek^.h);
     al_blit(tlo,al_screen,0,0,0,0,800,600);
end;
begin
init;
repeat
      nowosc(tabli);
      nowosc(tabli2);
      nowosc(al);
      stworz;
      okienka;
      pisz('Wybierz tryb',250,450,1);
      pisz('1-Komputer',0,500,1);
      pisz('2-Dwoch graczy ',500,500,1);
      pisz('3-Wyjscie',250,550,1);
      while not(al_key[al_key_1]or al_key[al_key_2] or al_key[al_key_3]) do
      al_readkey;
      if (al_key[al_key_1]) then  komputer;
      if (al_key[al_key_2]) then  dwoch;
      if (al_key[al_key_3]) then begin al_exit; break;end;
until false;
end.
