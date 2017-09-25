module BillsHelper

  UNIDADES = [
    '',
    'un ',
    'dos ',
    'tres ',
    'cuatro ',
    'cinco ',
    'seis ',
    'siete ',
    'ocho ',
    'nueve ',
    'uno'
  ]

  DECENAS = [
    '',
    'un ',
    'dos ',
    'tres ',
    'cuatro ',
    'cinco ',
    'seis ',
    'siete ',
    'ocho ',
    'nueve ',
    'diez ',
    'once ',
    'doce ',
    'trece ',
    'catorce ',
    'quince ',
    'dieciséis ',
    'diecisiete ',
    'dieciocho ',
    'diecinueve ',
    'veinte ',
    'veinti',
    'treinta ',
    'cuarenta ',
    'cincuenta ',
    'sesenta ',
    'setenta ',
    'ochenta ',
    'noventa '
  ]

  DECENAS_2 = [
    '',
    'diez',
    'once',
    'doce',
    'trece',
    'catorce',
    'quince',
    'dieciséis',
    'diecisiete',
    'dieciocho',
    'diecinueve',
    'veinte',
    'veinti',
    'treinta',
    'cuarenta',
    'cincuenta',
    'sesenta',
    'setenta',
    'ochenta',
    'noventa'
  ]

  CENTENAS = [
    '',
    'ciento ',
    'doscientos ',
    'trescientos ',
    'cuatrocientos ',
    'quinientos ',
    'seiscientos ',
    'setecientos ',
    'ochocientos ',
    'novecientos ',
    'cien'
  ]

  AGRUPADORES = [
    '',
    'mil ',
    'millones, ',
    'mil millones, ',
    'millón '
  ]

  def decimals(number)
    @num_s = number.to_s
    @num_length = @num_s.index('.')
    first_dec = @num_length + 1
    last_num = @num_s.length
    num_decimals = last_num - first_dec
    if num_decimals < 2
      @decimals = @num_s[first_dec] + '0'
    else
      @decimals = @num_s.slice(first_dec..last_num)
    end
    @decimals += '/100 M.N.'
    @decimals
  end

  def variables_to_number(number)
    @quantity_in_letters = ''
    decimals(number)
    @num_s = number.to_s
    @num_cent = @num_length / 3
    @num_dec = @num_length / 3
    @order = @num_length % 3
    @num_dec += 1 unless (@num_length % 3 < 2)
    @q_dec = @num_dec
    @q_cent = @num_cent
    if @num_length < 4
      @q_group = 0
    elsif @num_length >= 4 && @num_length < 7
      @q_group = 1
    elsif @num_length >= 7  && @num_length < 10
      @q_group = 2
    elsif @num_length >= 10  && @num_length < 13
      @q_group = 3
    end
    @num_length % 3 == 1 ? @num_unit = 1 : @num_unit = 0
  end

  def centenas
    number = @num_length - (@q_cent * 3)
    position = @num_s[number].to_i
    next_two = @num_s.slice((number + 1)..(number + 2)).to_i
    if (position == 1 && next_two == 0)
      @quantity_in_letters << CENTENAS[10]
    else
      @quantity_in_letters << CENTENAS[position]
    end
    @q_cent -= 1
  end

  def decenas
    result = 2 + (3 * (@q_dec - 1))
    first = @num_length - result
    second = first + 1
    slice_in_dec = @num_s.slice(first..second).to_i
    if (slice_in_dec < 21)
      @quantity_in_letters << DECENAS[slice_in_dec]
    elsif slice_in_dec == 21
      string = 'veintiún '
      @quantity_in_letters << string
    elsif (slice_in_dec > 21 && slice_in_dec < 30)
      string = DECENAS[21] + DECENAS[slice_in_dec.to_s[1].to_i]
      @quantity_in_letters << string
    elsif (slice_in_dec >= 30 && slice_in_dec < 40)
      string = DECENAS[22] + 'y ' + DECENAS[slice_in_dec.to_s[1].to_i]
      @quantity_in_letters << string
    elsif (slice_in_dec >= 40 && slice_in_dec < 50)
      string = DECENAS[23] + 'y ' + DECENAS[slice_in_dec.to_s[1].to_i]
      @quantity_in_letters << string
    elsif (slice_in_dec >= 50 && slice_in_dec < 60)
      string = DECENAS[24] + 'y ' + DECENAS[slice_in_dec.to_s[1].to_i]
      @quantity_in_letters << string
    elsif (slice_in_dec >= 60 && slice_in_dec < 70)
      string = DECENAS[25] + 'y ' + DECENAS[slice_in_dec.to_s[1].to_i]
      @quantity_in_letters << string
    elsif (slice_in_dec >= 70 && slice_in_dec < 80)
      string = DECENAS[26] + 'y ' + DECENAS[slice_in_dec.to_s[1].to_i]
      @quantity_in_letters << string
    elsif (slice_in_dec >= 80 && slice_in_dec < 90)
      string = DECENAS[27] + 'y ' + DECENAS[slice_in_dec.to_s[1].to_i]
      @quantity_in_letters << string
    elsif (slice_in_dec >= 90 && slice_in_dec < 100)
      string = DECENAS[28] + 'y ' + DECENAS[slice_in_dec.to_s[1].to_i]
      @quantity_in_letters << string
    end
    @q_dec -= 1
  end

  def unidades
    if @num_unit > 0
      @unit_value = @num_s[0].to_i
      @quantity_in_letters << UNIDADES[@unit_value]
    end
    @num_unit -= 1
  end

  def agrupadores
    if (@q_group > 0 && @q_group < 5)
      agr_string = AGRUPADORES[@q_group]
      if agr_string == 'millones, ' && @unit_value == 1
        agr_string = 'millón, '
      end
      @quantity_in_letters << agr_string
    end
    @q_group -= 1
  end

  def number_to_letters(number)
    variables_to_number(number)
    while @q_dec > 0
      if @order == 0
        centenas
        decenas
        agrupadores
      elsif @order == 1
        if @num_unit > 0
          unidades
          agrupadores
        end
        centenas
        decenas
        agrupadores
      else @order == 2
        decenas
        agrupadores
        centenas
      end
    end
    @quantity_in_letters << 'pesos '
    @quantity_in_letters.capitalize
  end

  def address(user)
    @address = user.store.delivery_address.street + ' ' + user.store.delivery_address.exterior_number + ' '
    @address += 'Int. ' + user.store.delivery_address.interior_number + ' ' unless user.store.delivery_address.interior_number.blank?
    @address += 'Col. ' + user.store.delivery_address.neighborhood + '.' + ' ' + user.store.delivery_address.city + ',' + ' ' + user.store.delivery_address.state
    @address
  end

end
