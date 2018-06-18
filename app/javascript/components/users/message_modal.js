import React, { Component } from 'react';
import Modal from 'react-modal';

const customStyles = {
  content : {
    top                   : '50%',
    left                  : '50%',
    right                 : 'auto',
    bottom                : 'auto',
    marginRight           : '-50%',
    transform             : 'translate(-50%, -50%)'
  }
};

Modal.setAppElement('#root')

class MessageModal extends React.Component {
  closeModal = () => {
    if (typeof this.props.closeModal === 'function') {
      this.props.closeModal()
    }
  }

  render() {
    return (
      <Modal
        isOpen={this.props.modalIsOpen}
        onAfterOpen={this.afterOpenModal}
        onRequestClose={this.closeModal}
        style={customStyles}
        contentLabel="Example Modal">

        <div className="row">
          <div className='modal-head col-12'>
            <button className="close pull-right" onClick={this.closeModal}>
              <span>&times;</span>
            </button>
            <div className="profile-pic-round-sm m-2"
                 style={{ display: "block", backgroundImage: `url(${this.props.profile_picture})`}}/>
            <p>
              Αποστολή μηνύματος:
              <strong> { this.props.username }</strong>
            </p>
          </div>
        </div>
        <div className="row">
          <div className='col-12'>
            <div className="form-group">
              <form action="/messages" method="post">
                <textarea name="message[body]" id="message_body" cols="5" className="form-control" required="required" placeholder="Γράψτε το μήνυμά σας"/>
                <input name="message[username]" id="message_username" value={this.props.username} type="hidden"/>
                <hr />
                <input name="commit" value="Αποστολή" className="btn btn-outline-primary float-right" data-disable-with="Αποστολή" type="submit"/>
              </form>
            </div>
          </div>
        </div>
      </Modal>
    )
  }
}

export default MessageModal;
