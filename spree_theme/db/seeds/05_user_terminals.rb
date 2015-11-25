# add seeds here, table_exists? do not work for sqlite in migration

  pc = Spree::UserTerminal.create(name: 'PC', medium_width: 'all' )
  phone = Spree::UserTerminal.create(name: 'Cellphone', medium_width: 'all' )
  pad = Spree::UserTerminal.create(name: 'Pad', medium_width: 'all' )
