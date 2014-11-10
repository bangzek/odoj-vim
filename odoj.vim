" vim: sw=2 ts=2 et gfn=Monospace\ 11 co=74
" BEGIN: WA copas script
if !exists('*Paste')
  " Fix UTF-16 surrogate pair
  function DecodeUTF16(text)
    return substitute(a:text,
          \ '\v([\uD800-\uD8FF\uD900-\uD9FF\uDA00-\uDAFF\uDB00-\uDBFF])'.
          \   '([\uDC00-\uDCFF\uDD00-\uDDFF\uDE00-\uDEFF\uDF00-\uDFFF])',
          \ '\=nr2char(0x10000 +'.
          \   '(char2nr(submatch(1)) - 0xD800) * 0x400 +'.
          \   '(char2nr(submatch(2)) - 0xDC00))',
          \ 'ge')
  endfunction

  function WaEmoji2Unicode(text)
    " Softbank+ Emoji
    let text = tr(a:text,
        \ ''.
        \ ''.
        \ ''.
        \ ''.
        \ ''.
        \ ''.
        \ ''.
        \ ''.
        \ '',
        \
        \ '👦👧💋👨👩👕👟📷☎📱📠💻👊👍☝✊✌✋🎿⛳🎾⚾🏄⚽🐟🐴🚗⛵✈🚃🚅❓❗❤💔🕐🕑🕒🕓🕔🕕🕖🕗🕘🕙🕚🕛🌸🔱🌹'.
        \ '🎄💍💎🏠⛪🏢🚉⛽🗻🎤🎥🎵🔑🎷🎸🎺🍴🍸☕🍰🍺⛄☁☀☔🌙🌄👼🐱🐯🐻🐶🐭🐳🐧😊😃😞😠💩📫📮📩📲😜😍😱😓🐵🐙'.
        \ '🐷👽🚀👑💡🍀💏🎁🔫🔍🏃🔨🎆🍁🍂👿👻💀🔥💼💺🍔⛲⛺♨🎡🎫💿📀📻📼📺👾〽🀄🆚💰🎯🏆🏁🎰🐎🚤🚲🚧🚹🚺🚼💉💤'.
        \ '⚡👠🛀🚽🔊📢🎌🔒🔓🌆🍳📖💱💹📡💪🏦🚥🅿🚏🚻👮🏣🏧🏥🏪🏫🏨🚌🚕🚶🚢🈁💟✴✳🔞🚭🔰♿📶♥♦♠♣➿🆕🆙🆒🈶'.
        \ '🈚🈷🈸🔴🔲🔳🉐🈹🈂🆔🈵🈳🈯🈺👆👇👈👉⬆⬇➡⬅↗↖↘↙▶◀⏩⏪🔯♈♉♊♋♌♍♎♏♐♑♒♓⛎🔝🆗©®📳📴'.
        \ '⚠💁📝👔🌺🌷🌻💐🌴🌵🚾🎧🍶🍻㊗🚬💊🎈💣🎉✂🎀㊙💽📣👒👗👡👢💄💅💆💇💈👘👙👜🎬🔔🎶💓💗💘💙💚💛💜✨⭐💨'.
        \ '💦⭕❌💢🌟❔❕🍵🍞🍦🍟🍡🍘🍚🍝🍜🍛🍙🍢🍣🍎🍊🍓🍉🍅🍆🎂🍱🍲😥😏😔😁😉😣😖😪😝😌😨😷😳😒😰😲😭😂😢☺😄'.
        \ '😡😚😘👀👃👂👄🙏👋👏👌👎👐🙅🙆💑🙇🙌👫👯🏀🏈🎱🏊🚙🚚🚒🚑🚓🎢🚇🚄🎍💝🎎🎓🎒🎏🌂💒🌊🍧🎇🐚🎐🌀🌾🎃🎑🍃'.
        \ '🎅🌅🌇🌃🌈🏩🎨🎩🏬🏯🏰🎦🏭🗼👱👲👳👴👵👶👷👸🗽💂💃🐬🐦🐠🐤🐹🐛🐘🐨🐒🐑🐺🐮🐰🐍🐔🐗🐫🐸🅰🅱🆎🅾👣™')
    " keycap and flags
    let map = { '': '#⃣', '': '1⃣', '': '2⃣', '': '3⃣',
              \ '': '4⃣', '': '5⃣', '': '6⃣', '': '7⃣',
              \ '': '8⃣', '': '9⃣', '': '0⃣',
              \ '': '🇯🇵', '': '🇺🇸', '': '🇫🇷', '': '🇩🇪',
              \ '': '🇮🇹', '': '🇬🇧', '': '🇪🇸', '': '🇷🇺',
              \ '': '🇨🇳', '': '🇰🇷'}
    let text = substitute(text,
        \ '[\uE210\uE21C-\uE225\uE50B-\uE514]',
        \ '\=map[submatch(0)]',
        \ 'ge')
    " F### char
    let text = substitute(text,
        \ '[\uF000-\uF0FF\uF100-\uF1FF\uF200-\uF2FF\uF300-\uF3FF'.
        \ '\uF400-\uF4FF\uF500-\uF5FF\uF600-\uF6FF]',
        \ '\=nr2char(0x10000 + char2nr(submatch(0)))',
        \ 'ge')

    return text
  endfunction

  command Paste call Paste()
  function Paste()
    if getregtype('*') == ''
      return
    endif
    let texts = split(WaEmoji2Unicode(DecodeUTF16(getreg('*'))), "\n")
    if line('$') == 1 && getline('.') ==# ''
      call setline(1, texts)
    else
      call append(line('.'), texts)
    endif
    execute '+'.len(texts)
    redraw
  endfunction
endif
" END: WA copas script

" Script Settings
let g:ODOJ = {'juz_urut': 1, 'DEBUG': 0, 'Docdir': 'Documents'}

" Format number to be left padded with zero
function Fnum(n)
  if strlen(a:n) == 1
    return '0' . a:n
  endif
  return a:n . ''
endfunction

" Next Juz
function Njuz(juz)
  if a:juz >= 30
    return 1
  else
    return a:juz + 1
  endif
endfunction

" Juz differences (a - b)
function Jdiff(a, b)
  if a:a < a:b && a:a < 10 && a:b > 20
    return a:a - a:b + 30
  else
    return a:a - a:b
  endif
endfunction

" To Blocked Number
function NumB(str)
  return tr(a:str, '1234567890', '1⃣2⃣3⃣4⃣5⃣6⃣7⃣8⃣9⃣0⃣')
endfunction

" From Blocked Number
function NumA(str)
  return tr(a:str, '1⃣2⃣3⃣4⃣5⃣6⃣7⃣8⃣9⃣0⃣', '1234567890')
endfunction

command WA call WA()
function WA()
  " split line by many space
  %s/\v {5,}/\r/ge
  " multiline
  g#\v^\[[0-9:/ .,apm]{7,}\] [^:]+: .+\n\_[^[]#call WA_multiline()
  " sederhanakan
  %s#\v^\[[0-9:/ .,apm]*<(\d\d?):(\d\d?)>[0-9:/ .,apm]*\] ([^:]+: )#[\1:\2] \3#
  %s/\v^\[(\d):(\d\d?\] [^:]+: )/[0\1:\2/e
  %s/\v^\[(\d\d):(\d)\] ([^:]+: )/[\1:0\2] \3/e
  " titipan
  %s/\v^(\[\d\d:\d\d\]) [^:]+: ([a-zA-Z][a-zA-Z'. ]{,13}[a-zA-Z.]) *: */\1 \2: /e
  " baris kosong
  %s/\v^\[\d\d:\d\d\] [^:]+:  *$//e
  " format akhir
  %s/\v^(\[\d\d:\d\d\]) ([^:]+: .+)/__\2 \1/
  " local custom
  silent! g/\v\c^__.*Via (SMS|Japri)/d
  silent! g/\v\c^__.*Perbaikan Laporan/d
  $
endfunction

function WA_multiline()
  let no = line('.')
  let end = line('$')
  let regex = '\v^\[[0-9:/ .,apm]{7,}\] [^:]+: '
  let prefix = matchstr(getline(no), regex)
  let no += 1
  let regex .= '.+'
  while no <= end
    let line = getline(no)
    if line !~# regex
      call setline(no, prefix . line)
      let no += 1
    else
      break
    endif
  endwhile
endfunction

command Jahit call jahit.run()
let jahit = {}
function jahit.run() dict
  " catat juz
  let self.loc = {}
  let self.mark = ''
  g /\v(◻|⌚|✅|➡) ([^:]+):/ call self.mark_juz()

  " proses map nama
  let self.map = {}
  g /\v^ *\% *([a-zA-Z][^:]*[^: ]) *: *([a-zA-Z][a-zA-Z'. ]{,13}[a-zA-Z.]) *$/ call self.parse_map()

  " proses laporan
  let self.lines = {}
  g /\v^__([^:]+): (.+)/ call self.parse_wa()
  for [k, v] in items(self.lines)
    call append(line("'" . self.loc[k]), v)
  endfor

  " hapus baris kosong di akhir
  while getline('$') =~# '\v^\s*$'
    $d
  endwhile

  %y*
  1/^›››/
endfunction

function jahit.mark_juz() dict
  let m = matchlist(getline('.'), @/)
  let name = tolower(m[2])
  if !has_key(self.loc, name)
    let self.loc[name] = self.incr_mark()
  endif
  execute 'mark ' . self.loc[name]
endfunction

function jahit.incr_mark() dict
  if self.mark ==# ''
    let self.mark = 'a'
  elseif self.mark ==# 'z'
    let self.mark = 'A'
  elseif self.mark ==# 'Z'
    let self.mark = 'a'
  else
    let self.mark = nr2char(char2nr(self.mark) + 1)
  endif
  return self.mark
endfunction

function jahit.parse_map() dict
  let m = matchlist(getline('.'), @/)
  let self.map[tolower(m[1])] = tolower(m[2])
  delete
endfunction

function jahit.parse_wa() dict
  let m = matchlist(getline('.'), @/)
  let name = tolower(m[1])
  if has_key(self.loc, name)
    call self.add_line(name, m[2])
  elseif has_key(self.map, name)
    if has_key(self.loc, self.map[name])
      call self.add_line(self.map[name], m[2])
    else
      execute 's/\v__([^:]+):/__'. escape(self.map[name], '/').':'
    endif
  endif
endfunction

function jahit.add_line(name, line) dict
  if !has_key(self.lines, a:name)
    let self.lines[a:name] = []
  endif
  call add(self.lines[a:name], '›››'.a:line)
  delete
endfunction

command Check call Check()
function Check()
  "✅ check the uniqueness of juz in a name
  "✅ check the last sign for each name is correct
  " if g:ODOJ.juz_urut = 1
  "✅ check the uniqueness of juz
  "✅ check all 30 juz present
  let s:c = {
\   'name': '',
\   'errors': [],
\   'jl_map': {},
\   'sign': '',
\   'jn_map': {},
\   'juz': 0,
\   'no': 0,
\ }

  g /\v(⬅|◻|⌚|✅|➡) ([^:]+):[ \t]+J(\d+)/ call s:each_check()
  call s:post_check()
  " check all 30 juz present
  if len(s:c.jn_map)
    for i in range(1, 30)
      if !has_key(s:c.jn_map, i)
        call add(s:c.errors, [0, printf('J%d tak ada!', i)])
      endif
    endfor
  endif
  " output error message
  if len(s:c.errors) > 0
    call reverse(s:c.errors)
    for [no, msg] in s:c.errors
      if no
        echom printf('%d: %s', no, msg)
        execute no
      else
        echom msg
      endif
    endfor
    unlet s:c
    return
  endif

  unlet s:c
  return 1
endfunction

function s:each_check()
  let no = line('.')
  let line = getline(no)
  let m = matchlist(line, @/)
  if len(m) > 0
    let sign = m[1]
    let name = m[2]
    let juz = +m[3]
    let schange = {
    \ '⬅': {'⬅':1, '◻':1, '⌚':1, '✅':1, '➡':1},
    \ '✅': {'➡':1},
    \ '➡': {'➡':1},
    \ }

    if name !=# s:c.name
      call s:post_check()
      let s:c.name = name
      let s:c.jl_map = {}
      let s:c.sign = ''
      let s:c.juz = 0
    endif

    if name ==# '--'
      if sign !=# '◻'
        call add(s:c.errors, [no, 'harusnya ◻!'])
      endif
      let s:c.name = ''
    else

      if has_key(s:c.jl_map, juz)
        call add(s:c.errors, [no, printf('J%d dobel!', juz)])
      else
        let s:c.jl_map[juz] = no
      endif

      if s:c.sign ==# '' ||
       \ (has_key(schange, s:c.sign) && has_key(schange[s:c.sign], sign))
        if sign ==# '◻' || sign ==# '⌚'
          if line =~# '\v\@\d'
            call add(s:c.errors, [no, printf('J%d salah tanda!', juz)])
          endif
          " check that (-#) == juz - s:c.juz - 1
          if s:c.juz && line =~ '\v[(]-\d+[)]'
            let m = matchlist(line, '\v[(]-(\d+)[)]')
            let debt = +m[1]
            let calc = Jdiff(juz, s:c.juz) - 1
            if debt !=# calc
              call add(s:c.errors, [no, printf('harusnya (-%d)!', calc)])
            endif
          endif
        else
          if line !~# '\v\@\d'
            call add(s:c.errors, [no, printf('J%d salah tanda!', juz)])
          endif
        endif
        let s:c.sign = sign
      else
        call add(s:c.errors, [no, printf('J%d salah tanda!', juz)])
      endif
    endif

    if sign !=# '➡'
      let s:c.juz = juz
    endif
    let s:c.no = no
  endif
endfunction

function s:post_check()
  if g:ODOJ.juz_urut && s:c.juz
    if has_key(s:c.jn_map, s:c.juz)
      call add(s:c.errors, [s:c.no, printf('J%d dobel!', s:c.juz)])
    else
      let s:c.jn_map[s:c.juz] = s:c.name
    endif
  endif

  if len(s:c.name) && s:c.sign !~# '\v(◻|⌚|✅|➡)'
    call add(s:c.errors, [s:c.no, s:c.name.' salah tanda!'])
  endif
endfunction

command Stat call Stat()
function Stat()
  if !Check()
    return
  endif

  1s/^.* Tilawah/📊 Tilawah/
  silent! g /◻ --:/ d
  silent! g /➡/ d

  let s:status = {}
  " kode status
  " k : kholas
  " h : bayar hutang saja
  " p : perpanjangan
  " t : tanpa kabar

  g /\v◻ ([^:]+):/ call s:each_stat('t')
  g /\v⌚ ([^:]+):/ call s:each_stat('p')
  g /\v⬅ ([^:]+):/ call s:each_stat('h')
  g /\v✅ ([^:]+):/ call s:each_stat('k')

  let member = 0
  let stats = {'k':0, 'h':0, 'p':0, 't':0}
  for [n, s] in items(s:status)
    let stats[s] += 1
    let member += 1
  endfor
  unlet s:status

  if line('$') > 5 && !g:ODOJ.DEBUG
    " delete the rest
    6,$d
  endif

  " output statistik
  let outs = []
  if stats['k'] > 0
    call add(outs, '✅'.stats['k'])
  endif
  if stats['h'] > 0
    call add(outs, '⬅'.stats['h'])
  endif
  if stats['p'] > 0
    call add(outs, '⌚'.stats['p'])
  endif
  if stats['t'] > 0
    call add(outs, '📵'.stats['t'])
  endif
  if member != 30
    call add(outs, '👥'.member)
  endif
  call append(5, [
\   join(outs),
\   '',
\   'Semoga esok lebih baik lagi 🙏',
\ ])

  " copy ke clipboard
  %y*
endfunction

function s:each_stat(v)
  let m = matchlist(getline('.'), @/)
  let s:status[m[1]] = a:v
  delete
endfunction

command Qstat call Qstat()
function Qstat()
  2,5d
  2s/📵/◻/e
  3,$d
  %y*
endfunction

command Besok call besok.run()
let besok = {}
function besok.run() dict
  if !Check()
    return
  endif

  " baris pertama
  1
  " hari besok
  let besok = {
\   'ahad': 'Senin',
\   'senin': 'Selasa',
\   'selasa': 'Rabu',
\   'rabu': 'Kamis',
\   'kamis': 'Jum''at',
\   'jum''at': 'Sabtu',
\   'sabtu': 'Ahad',
\ }
  execute 's/\v\c' .
\   join(keys(besok), '|') .
\   '/\=besok[tolower(submatch(0))]/'
  " tanggal hijriah besok
  s/\v(\d\d?) /\=Fnum(Njuz(submatch(1))).' '/

  " tanggal besok
  2,3s/\v<\d\d?>/\=Njuz(submatch(0))/g

  " hapus baris bayar hutang
  let self.paid = {}
  silent! g /\v⬅ ([^:]+):/ call self.bayar()

  " catat baris juz
  3/\v(◻|⌚|✅)/
  let no = line('.')

  " hapus @waktu
  %s/\v(✅ .+) *\@\d.*/\1/e
  " trim
  %s/\v[ \t]+$//e

  " hutang +1
  %s/\v◻ ([^:]+):([ \t]+J)(\d+) [(]-(\d+)[)]/\='◻ '.submatch(1).':'.
    \ submatch(2).Fnum(Njuz(+submatch(3))).' (-'.(submatch(4)+1).')'.
    \ get(self.paid, submatch(1), '*')/e
  %s/\v⌚ ([^:]+):([ \t]+J)(\d+) [(]-(\d+)[)]/\='◻ '.submatch(1).':'.
    \ submatch(2).Fnum(Njuz(+submatch(3))).' (-'.(submatch(4)+1).')'.
    \ get(self.paid, submatch(1), '+')/e
  " hutang 1
  %s/\v◻ ([^:]+):([ \t]+J)(\d+)$/\='◻ '.submatch(1).':'.
    \ submatch(2).Fnum(Njuz(+submatch(3))).' (-1)'.
    \ get(self.paid, submatch(1), '*')/e
  %s/\v⌚ ([^:]+):([ \t]+J)(\d+)$/\='◻ '.submatch(1).':'.
    \ submatch(2).Fnum(Njuz(+submatch(3))).' (-1)'.
    \ get(self.paid, submatch(1), '+')/e
  " tanpa hutang
  %s/\v✅ ([^:]+:[ \t]+J)(\d+)/\='◻ '.submatch(1).
    \ Fnum(Njuz(+submatch(2)))/e

  unlet self.paid
  " tak ada orangnya
  silent! g/\v◻ --:/s/ *(-[0-9]\+)//
  " kecepetan :)
  let self.saving = ['']
  silent! g /➡/ call self.nabung()
  if len(self.saving) > 1
    call append('$', self.saving)
  endif
  unlet self.saving

  " pindahkan juz 01 ke baris awal
  if g:ODOJ.juz_urut
    /\v◻ [^:]+:[ \t]+J01/d
    execute no.'put!'
  endif

  " copy ke clipboard
  %y*
endfunction

function besok.bayar() dict
  let m = matchlist(getline('.'), @/)
  let self.paid[m[1]] = ''
  delete
endfunction

function besok.nabung() dict
  s/^➡ /__/
  s/\v-(\d+)/\='-'.(1+submatch(1))/e
  s/@[0-9.:]\+$/&-1/e
  call add(self.saving, getline('.'))
  delete
endfunction

command Rload call Rload()
function Rload()
  1
  let line = getline('.')
  if line !~# '^='
    echom "Invalid report load!"
    return
  endif
  if !exists('g:SDCARD')
    let g:SDCARD = expand('<sfile>:p:h')
  endif
  let dir = g:SDCARD.'/'. g:ODOJ.Docdir .'/'.line[1:]
  if !isdirectory(dir)
    echom 'Folder not found: '.dir
    return
  endif

  if line('.') == line('$')
    echom 'No file to load!'
    return
  endif

  let list = []
  while line('.') < line('$')
    +1
    let line = getline('.')
    let clist = split(glob(dir.'/'.line.'*'), '\n')
    if !len(clist)
      echom 'File '.line.' not found!'
      return
    endif
    call extend(list, clist)
  endwhile

  if !g:ODOJ.DEBUG
    %d
  endif
  execute '$read '.escape(dir.'/!Raport.txt', ' #!')
  for file in list
    execute '$read '.escape(file, ' #!')
  endfor
endfunction

command Raport call raport.run()
let raport = {}
function raport.run() dict
  call self.reset()

  " parse template
  g /\v^(\d\d)\. ([^:]+):(\t+)📝/ call self.parse_template()

  " make search not wrap to top
  let old_ws = &wrapscan
  set nowrapscan
  " search all day result from the top
  let fail = 0
  let v:errmsg = ''
  silent! 0 /\v^\@?(14\d\d\.\d\d).(\d\d) Tilawah (\S+)/
  while v:errmsg ==# ''
    if !self.each()
      let fail = 1
      break
    endif

    let v:errmsg = ''
    silent! -1 /\v^\@?(14\d\d\.\d\d).(\d\d) Tilawah (\S+)/
  endwhile
  let &wrapscan = old_ws
  if fail
    return
  endif

  " clean blank line
  1
  g /^\s*$/ d
  " clean the rest
  if !g:ODOJ.DEBUG && line('$') != 1
    %d
  endif

  " output
  call append(0, self.output())

  " hapus baris kosong di akhir
  if getline('$') =~# '\v^\s*$'
    $d
  endif

  " copy ke clipboard
  %y*
endfunction

function raport.reset() dict
  let self.member = {}
  let self.names = []
  let self.nday = 0
  let self.serial = ''
  let self.week = 0
  let self.day_beg = ''
  let self.day_end = ''
  let self.hday_beg = 0
  let self.hday_end = 0
  let self.mday_beg = 0
  let self.mday_end = 0
  let self.hmon_beg = ''
  let self.hmon_end = ''
  let self.mmon_beg = ''
  let self.mmon_end = ''
  let self.hyear_beg = 0
  let self.hyear_end = 0
  let self.myear_beg = 0
  let self.myear_end = 0
  let self.group = ''
  let self.total = 0
  let self.ranks = {'🎓': 0, '📗': 0, '📙': 0, '📕': 0}
endfunction

function raport.parse_template() dict
  let m = matchlist(getline('.'), @/)
  let self.member[m[2]] = {
  \    'no': m[1],
  \  'name': m[2],
  \ 'space': m[3],
  \   'day': [],
  \}
  call add(self.names, m[2])
  delete
endfunction

function raport.each() dict
  let m = matchlist(getline('.'), @/)
  let self.nday += 1
  if !len(self.serial)
    let self.week = float2nr(ceil(+m[2] / 7.0))
    let self.serial = m[1].'-'.self.week
  endif
  if !len(self.day_beg)
    let self.day_beg = m[3]
  endif
  let self.day_end = m[3]
  delete

  " next line is hijri date
  let m = matchlist(getline('.'), '\v^\t(\d\d?) (\S+) (\d+)H')
  if !len(m)
    return
  end
  if !self.hyear_beg
    let self.hday_beg = +m[1]
    let self.hmon_beg  = m[2]
    let self.hyear_beg = m[3]
  end
  let self.hday_end = +m[1]
  let self.hmon_end  = m[2]
  let self.hyear_end = m[3]
  delete

  " next line is masehi date
  let m = matchlist(getline('.'), '\v^\t(\d\d?) (\S+) (\d+)')
  if !len(m)
    return
  end
  if !self.myear_beg
    let self.mday_beg = +m[1]
    let self.mmon_beg  = m[2]
    let self.myear_beg = m[3]
  end
  let self.mday_end = +m[1]
  let self.mmon_end  = m[2]
  let self.myear_end = m[3]
  delete

  " next line is group line
  if !len(self.group)
    let self.group = getline('.')
  end
  delete

  for user in keys(self.member)
    call add(self.member[user].day, {'done':0, 'at':[]})
  endfor

  " find juz line
  -1 /\v(⬅|◻|⌚|✅) ([^:]+):/

  return self.process_juz()
endfunction

function raport.process_juz() dict
  let m = matchlist(getline('.'), @/)
  while len(m)
    let sign = m[1]
    let user = m[2]
    if has_key(self.member, user)
      let rec = self.member[user].day[self.nday - 1]
      if sign ==# '⬅' || sign ==# '✅'
        let rec.done = sign ==# '✅'
        let m = matchlist(getline('.'), '\v\@(\d+)')
        if !len(m)
          return
        endif
        call add(rec.at, +m[1])
      endif
      delete
    else
      +1
    endif

    let m = matchlist(getline('.'), '\v(⬅|◻|⌚|✅|➡) ([^:]+):')
  endwhile
  return 1
endfunction

function raport.output() dict
  let shmon = {
  \ 'Muharram':       'Muhrrm',
  \ 'Safar':          'Safar',
  \ 'Rabiul Awal':    'Rab Aw',
  \ 'Rabiul Akhir':   'Rab Akh',
  \ 'Jumadil Awal':   'Jum Aw',
  \ 'Jumadil Akhir':  'Jum Akh',
  \ 'Rajab':          'Rajab',
  \ "Sya'ban":        "Sya'ban",
  \ 'Ramadhan':       'Ramdhn',
  \ 'Syawal':         'Syawal',
  \ 'Dzulqaidah':     'Dzulq',
  \ 'Dzulhijjah':     'Dzulh',
  \}
  let smmon = {
  \ 'Januari':    'Jan',
  \ 'Februari':   'Feb',
  \ 'Maret':      'Mar',
  \ 'April':      'Apr',
  \ 'Mei':        'Mei',
  \ 'Juni':       'Jun',
  \ 'Juli':       'Jul',
  \ 'Agustus':    'Agu',
  \ 'September':  'Sep',
  \ 'Oktober':    'Okt',
  \ 'November':   'Nov',
  \ 'Desember':   'Des',
  \}

  let out = [
  \ '=' . self.serial . ' Raport ',
  \ "\t" . self.day_beg . '–' . self.day_end,
  \ "\t",
  \ "\t",
  \ self.group,
  \]

  if self.nday < 7
    let out[0] .= 'Sementara'
  else
    let out[0] .= 'Pekan ke-' . self.week
  endif

  if self.hyear_beg == self.hyear_end
    if self.hmon_beg == self.hmon_end
      let out[2] .= printf('%s–%s %s %dH',
        \ Fnum(self.hday_beg), Fnum(self.hday_end), self.hmon_beg, self.hyear_beg)
    else
      let out[2] .= printf('%s %s–%s %s %dH',
        \ Fnum(self.hday_beg), shmon[self.hmon_beg],
        \ Fnum(self.hday_end), shmon[self.hmon_end], self.hyear_beg)
    endif
  else
    let out[2] .= printf('%s %s %dH–%s %s %dH',
      \ Fnum(self.hday_beg), shmon[self.hmon_beg], self.hyear_beg,
      \ Fnum(self.hday_end), shmon[self.hmon_end], self.hyear_end)
  endif

  if self.myear_beg == self.myear_end
    if self.mmon_beg == self.mmon_end
      let out[3] .= printf('%s–%s %s %d',
        \ Fnum(self.mday_beg), Fnum(self.mday_end), self.mmon_beg, self.myear_beg)
    else
      let out[3] .= printf('%s %s–%s %s %d',
        \ Fnum(self.mday_beg), smmon[self.mmon_beg],
        \ Fnum(self.mday_end), smmon[self.mmon_end], self.myear_beg)
    endif
  else
    let out[2] .= printf('%s %s %d–%s %s %d',
      \ Fnum(self.mday_beg), smmon[self.mmon_beg], self.myear_beg,
      \ Fnum(self.mday_end), smmon[self.mmon_end], self.myear_end)
  endif

  for name in self.names
    let user = self.member[name]
" TODO: add time grid
" 🕛🕐🕑🕒🕓🕔🕕🕖🕗🕘🕙🕚
" 🌙☀🔹
    let sval = 0
    let jval = 0
    let srow = ''
    let jrow = ''
    for d in user.day
      if len(d.at)
        if d.done
          let sval += 2
          let srow .= '✅'
        else
          let sval += 1
          let srow .= '☑'
        endif
        let jval += len(d.at)
        let jrow .= NumB(len(d.at))
      else
        let srow .= '◻'
        let jrow .= '➖'
      endif
    endfor
    let total = sval + jval
    let rank = self.rank(total)
    let self.total += min([total, 3 * self.nday])
    let self.ranks[rank] += 1

    call add(out, '')
    call add(out, printf('%s. %s:%s📝%s%s',
            \ user.no, user.name, user.space, NumB(Fnum(total)), rank))
    call add(out, printf("\t\t%s: %02d", srow, sval))
    call add(out, printf("\t\t%s: %02d", jrow, jval))
  endfor

  let avg = self.total / floor(len(self.names))
  let davg = avg / self.nday
  call add(out, '')
  call add(out, printf("Nilai Rata-Rata: %.1f (%.2f/hari)", avg, davg))
  call add(out, printf("🎓%d 📗%d 📙%d 📕%d",
          \ self.ranks['🎓'], self.ranks['📗'],
          \ self.ranks['📙'], self.ranks['📕']))

  return out
endfunction

function raport.rank(num) dict
  if a:num >= 3 * self.nday
    return '🎓'
  elseif a:num >= ceil(16 / 7.0 * self.nday)
    return '📗'
  elseif a:num >= ceil(11 / 7.0 * self.nday)
    return '📙'
  else
    return '📕'
  endif
endfunction

command Nilai call Nilai()
function Nilai()
  g!/^\d/d
  %s/.*📝//
  %s/[🎓📗📙📕]//
  g /\v(1⃣|2⃣|3⃣|4⃣|5⃣|6⃣|7⃣|8⃣|9⃣|0⃣)/ call setline('.', NumA(getline('.')))
	%y*
endfunction

let split = {}
command Split call split.run()
function split.run() dict
  " make search not wrap to top
  let old_ws = &wrapscan
  set nowrapscan

  let self.index = 0
  let self.list = []
  let v:errmsg = ''
  silent! 0 /^\s*$/
  while v:errmsg ==# ''
    silent! 1,-1d
    call add(self.list, split(@", '\n'))
    silent! d

    let v:errmsg = ''
    silent! /^\s*$/
  endwhile
  if line('$') > 1
    silent! %d
    call add(self.list, split(@", '\n'))
  endif
  call self.render()

  let &wrapscan = old_ws
endfunction

function split.render() dict
  silent! %d
  call setline(1, self.list[self.index])
  %y*
endfunction

command Sprev call split.prev()
function split.prev() dict
  if !len(self.list)
    echom ':Split dulu!'
    return
  endif

  if !self.index
    echom 'Awal!'
  else
    let self.index -= 1
    call self.render()
  endif
endfunction

command Snext call split.next()
function split.next() dict
  if !len(self.list)
    echom ':Split dulu!'
    return
  endif

  if self.index == len(self.list) - 1
    echom 'Akhir!'
  else
    let self.index += 1
    call self.render()
  endif
endfunction

command Sfirst call split.first()
function split.first() dict
  if !len(self.list)
    echom ':Split dulu!'
    return
  endif

  let self.index = 0
  call self.render()
endfunction

command Slast call split.last()
function split.last() dict
  if !len(self.list)
    echom ':Split dulu!'
    return
  endif

  let self.index = len(self.list) - 1
  call self.render()
endfunction
