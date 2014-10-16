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
let g:ODOJ = {'juz_urut':1}

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
  g/\v(◻|✅|➡) ([^:]+):/call self.mark_juz()

  " proses map nama
  let self.map = {}
  g/^ *%/call self.parse_map()

  " proses laporan
  let self.lines = {}
  g/\v^__[^:]+: .+/call self.parse_wa()
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
  let m = matchlist(getline('.'), '\v(◻|⌚|✅|➡) ([^:]+):')
  if len(m) > 0
    let name = tolower(m[2])
    if !has_key(self.loc, name)
      let self.loc[name] = self.incr_mark()
    endif
    execute 'mark ' . self.loc[name]
  endif
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
  let m = matchlist(getline('.'),
        \ '\v^ *\% *([a-zA-Z][^:]*[^: ]) *: *'.
        \ '([a-zA-Z][a-zA-Z''. ]{,13}[a-zA-Z.]) *$')
  if len(m) > 0
    let self.map[tolower(m[1])] = tolower(m[2])
    delete
  endif
endfunction

function jahit.parse_wa() dict
  let m = matchlist(getline('.'), '\v^__([^:]+): (.+)')
  if len(m) > 0
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

  g /\v(⬅|◻|⌚|✅|➡) [^:]+:[ \t]+J\d+/ call s:each_check()
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
  let m = matchlist(line, '\v(⬅|◻|⌚|✅|➡) ([^:]+):[ \t]+J(\d+)')
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

  g /\v◻ [^:]+:/ call s:each_blank_stat()
  g /\v⌚ [^:]+:/ call s:each_time_stat()
  g /\v⬅ [^:]+:/ call s:each_debt_stat()
  g /\v✅ [^:]+:/ call s:each_done_stat()

  let member = 0
  let stats = {'k':0, 'h':0, 'p':0, 't':0}
  for [n, s] in items(s:status)
    let stats[s] += 1
    let member += 1
  endfor
  unlet s:status

  if line('$') > 5
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

function s:each_blank_stat()
  let line = getline('.')
  let m = matchlist(line, '\v◻ ([^:]+):')
  if len(m) > 0
    let s:status[m[1]] = 't'
    delete
  endif
endfunction

function s:each_time_stat()
  let line = getline('.')
  let m = matchlist(line, '\v⌚ ([^:]+):')
  if len(m) > 0
    let s:status[m[1]] = 'p'
    delete
  endif
endfunction

function s:each_debt_stat()
  let m = matchlist(getline('.'), '\v⬅ ([^:]+):')
  if len(m) > 0
    let s:status[m[1]] = 'h'
    delete
  endif
endfunction

function s:each_done_stat()
  let m = matchlist(getline('.'), '\v✅ ([^:]+):')
  if len(m) > 0
    let s:status[m[1]] = 'k'
    delete
  endif
endfunction

command Qstat call Qstat()
function Qstat()
  2,5d
  2s/📵/◻/e
  3,$d
  %y*
endfunction

command Besok call Besok()
function Besok()
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
  silent! g/⬅/d

  " catat baris juz
  3/\v(◻|⌚|✅)/
  let no = line('.')

  " hapus @waktu
  %s/\v(✅ .+) *\@\d.*/\1/e
  " trim
  %s/\v[ \t]+$//e

  " hutang +1
  %s/\v◻ ([^:]+:[ \t]+J)(\d+) [(]-(\d+)[)]/\='◻ '.submatch(1).
    \ Fnum(Njuz(+submatch(2))).' (-'.(submatch(3)+1).')*'/e
  %s/\v⌚ ([^:]+:[ \t]+J)(\d+) [(]-(\d+)[)]/\='◻ '.submatch(1).
    \ Fnum(Njuz(+submatch(2))).' (-'.(submatch(3)+1).')'/e
  " hutang 1
  %s/\v◻ ([^:]+:[ \t]+J)(\d+)$/\='◻ '.submatch(1).
    \ Fnum(Njuz(+submatch(2))).' (-1)*'/e
  %s/\v⌚ ([^:]+:[ \t]+J)(\d+)$/\='◻ '.submatch(1).
    \ Fnum(Njuz(+submatch(2))).' (-1)'/e
  " tanpa hutang
  %s/\v✅ ([^:]+:[ \t]+J)(\d+)/\='◻ '.submatch(1).
    \ Fnum(Njuz(+submatch(2)))/e
  " tak ada orangnya
  silent! g/\v◻ --:/s/ *(-[0-9]\+)//
  " kecepetan :)
  let s:earlies = ['']
  silent! g/➡/call s:Earlies()
  if len(s:earlies) > 1
    call append('$', s:earlies)
  endif
  unlet s:earlies

  " pindahkan juz 01 ke baris awal
  if g:ODOJ.juz_urut
    /\v◻ [^:]+:[ \t]+J01/d
    execute no.'put!'
  endif

  " copy ke clipboard
  %y*
endfunction

function s:Earlies()
  s/^➡ /__/
  s/\v-(\d+)/\='-'.(1+submatch(1))/e
  s/@[0-9.:]\+$/&-1/e
  call add(s:earlies, getline('.'))
  delete
endfunction
