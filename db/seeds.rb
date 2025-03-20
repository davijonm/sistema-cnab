if TransactionType.count.zero?
  TransactionType.create([
    { code: 1, description: 'Débito', nature: 'Entrada', sign: '+' },
    { code: 2, description: 'Boleto', nature: 'Saída', sign: '-' },
    { code: 3, description: 'Financiamento', nature: 'Saída', sign: '-' },
    { code: 4, description: 'Crédito', nature: 'Entrada', sign: '+' },
    { code: 5, description: 'Recebimento Empréstimo', nature: 'Entrada', sign: '+' },
    { code: 6, description: 'Vendas', nature: 'Entrada', sign: '+' },
    { code: 7, description: 'Recebimento TED', nature: 'Entrada', sign: '+' },
    { code: 8, description: 'Recebimento DOC', nature: 'Entrada', sign: '+' },
    { code: 9, description: 'Aluguel', nature: 'Saída', sign: '-' }
  ])
end

if User.count.zero?
  User.create(email: "bycoders@exemplo.com", password: "senha1234", password_confirmation: "senha1234")
end
