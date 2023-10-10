import React from "react";
import PropTypes from "prop-types";
import { Card, Button } from "react-bootstrap";
import { useNavigate } from "react-router-dom";
import "./ProvidersShowAll.css";

const ProviderCard = (props) => {
  
  const navigate = useNavigate();
  
  const aProvider = props.providerCard;

  const specializations = aProvider.specializations?.map((item) => item.specialization.name).join(" & ");

  const handleEditClick = () => {
    
    navigate (`/provider/${aProvider.id}/details`, { state: { provider: aProvider, type: "Provider_Details" },
    });
  };
  return (
    <div className="col-4">
      <Card className="m-2 card-hover card-Size-Providers">
        <Card.Img
          variant="top"
          src={aProvider.userData.avatarUrl}
          className="rounded-top-md img-fluid  Profile-Picture"
        />
        <Card.Body>
          <h5 className="mb-0 fw-semi-bold">
            <u className="text">
              {aProvider.tittle.name}
              {aProvider.userData.firstName} {aProvider.userData.mi} {aProvider.userData.lastName}
            </u>
          </h5>
          <h1> </h1>
          <div>
            <h6>
              <span className="card-text">{specializations}</span>
            </h6>
          </div>
          <div className="row">
            <span className="card-text">Phone: {aProvider.phone}</span>
          </div>
          <div className="row">
            <span className="card-text">Fax: {aProvider.fax}</span>
          </div>
          <div className="row Providers-button">
            <Button onClick={handleEditClick} type="button" className="btn btn-primary">
              Show More Information
            </Button>
          </div>
        </Card.Body>
      </Card>
    </div>
  );
};
ProviderCard.propTypes = {
  providerCard: PropTypes.shape({
    id: PropTypes.number,
    phone: PropTypes.string,
    fax: PropTypes.string,
    userData: PropTypes.element,
    firstName: PropTypes.string,
    lastName: PropTypes.string,
    mi: PropTypes.string,
    email: PropTypes.string,
    avatarUrl: PropTypes.string,
    tittle: PropTypes.string,
    name: PropTypes.string,
    specializations: PropTypes.arrayOf({ specialization: PropTypes.string }),
  }),
};

export default ProviderCard;
