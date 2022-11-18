import Modal from 'react-bootstrap/Modal';
import Button from 'react-bootstrap/Button';
import { useDispatch } from "react-redux";

function UserDependentConfirmation(props) {
    const dispatch = useDispatch();
    // Dispatch to remove the selected dependent account then close the modal
    const removeDependent = (id) => {
        dispatch({
          type: "REMOVE_DEPENDENT",
          payload: id
        });
        props.handleClose();
      }
    // Renders a modal to confirm if the user wants to remove the selected dependent account
    return (
        <Modal show={props.show} onHide={props.handleClose}>
        <Modal.Header closeButton>
          <Modal.Title>Confirm Delete</Modal.Title>
        </Modal.Header>
        <Modal.Body>Are you sure you would like to remove this dependent account?</Modal.Body>
        <Modal.Footer>
          <Button variant="secondary" onClick={props.handleClose}>
            Cancel
          </Button>
          <Button variant="primary" onClick={()=>removeDependent(props.dependentId)}>
            Confirm Delete
          </Button>
        </Modal.Footer>
      </Modal>
    );
}

export default UserDependentConfirmation;