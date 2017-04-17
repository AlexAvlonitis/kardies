class UsersDetailsIndex < Chewy::Index
  settings analysis: {
    analyzer: {
      default: {
        tokenizer: 'whitespace',
        filter: ['lowercase']
      }
    }
  }

  define_type UserDetail.active

end
