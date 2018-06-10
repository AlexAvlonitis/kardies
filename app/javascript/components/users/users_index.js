import React, { Component } from 'react'
import CardDeck from './card_deck'
import Search from './search'

export default class UsersIndex extends Component {
  constructor(props) {
    super(props);
  }

  render() {
    return(
      <div>
        <div className="row">
          <Search />
        </div>
        <div className="row justify-content-center">
          <CardDeck />
        </div>
      </div>
    )
  }
}
