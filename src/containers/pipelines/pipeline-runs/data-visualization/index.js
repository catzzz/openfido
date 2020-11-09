import React, { useState } from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';

import { DATA_VISUALIZATION_TAB } from 'config/pipeline-runs';
import { pipelineStates } from 'config/pipeline-status';
import {
  StyledH2,
  StyledH4,
  StyledButton,
} from 'styles/app';
import colors from 'styles/colors';
import { useSelector } from 'react-redux';
import OverviewTabMenu from '../overview-tab-menu';
import AddChartPopup from '../add-chart-popup';

const StyledDataVisualization = styled.div`
  padding: 16px 20px;
  padding: 1rem 1.25rem;
  header {
    display: flex;
    h2 {
      margin-right: 4px;
      margin-right: 0.25rem;
      width: 108px;
    }
    ul {
      margin-top: 3px;
      margin-top: 0.1875rem;
    }
  }
  section {
    margin-top: 16px;
    margin-top: 1rem;
    background-color: ${colors.white};
    color: ${colors.black};
    border-radius: 6px;
    max-width: 972px;
    font-size: 18px;
    font-size: 1.125rem;
    line-height: 21px;
    line-height: 1.3125rem;
    padding: 24px 28px;
    padding: 1.5rem 1.75rem;
  }
`;

const AddChartButton = styled(StyledButton)`
  &.ant-btn {
    color: ${colors.grayText};
    height: 30px;
    font-weight: 300;
    &:hover {
      color: ${colors.lightBlue};
    }
    align-items: center;
    span:before {
      content: "+";
      font-size: 30px;
      font-size: 1.875rem;
      display: inline-block;
      margin-right: 4px;
      margin-righT: 0.25rem;
    }
    span {
      display: flex;
    }
  }
`;

const DataVisualization = ({
  pipelineInView, pipelineRunSelected, sequence, setDisplayTab,
}) => {
  const [showAddChartPopup, setShowAddChartPopup] = useState(false);

  const charts = useSelector((state) => state.charts.charts[pipelineRunSelected && pipelineRunSelected.uuid]);

  return (
    <>
      <StyledDataVisualization>
        <header>
          <StyledH2 color="black">
            Run #
            {sequence}
          </StyledH2>
          <OverviewTabMenu
            displayTab={DATA_VISUALIZATION_TAB}
            setDisplayTab={setDisplayTab}
            dataVisualizationReady={pipelineRunSelected && pipelineRunSelected.status === pipelineStates.COMPLETED}
          />
        </header>
        <AddChartButton
          color="white"
          width={130}
          onClick={() => setShowAddChartPopup(true)}
        >
          Add A Chart
        </AddChartButton>
        {charts && charts.map(({ artifact, title }) => (
          <section>
            <StyledH4>{title}</StyledH4>
            <img src={artifact.url} alt={artifact.name} width="100%" />
          </section>
        ))}
      </StyledDataVisualization>
      {showAddChartPopup && (
        <AddChartPopup
          handleOk={() => setShowAddChartPopup(false)}
          handleCancel={() => setShowAddChartPopup(false)}
          pipeline_uuid={pipelineInView}
          pipeline_run_uuid={pipelineRunSelected && pipelineRunSelected.uuid}
          artifacts={[
            ...pipelineRunSelected && pipelineRunSelected.artifacts,
            {
              name: 'sample-image-artifact.png',
              uuid: 'some-uuidhere',
              url: 'http://localhost:9000/workflow-service/holy-cross-60-min.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=minio_access_key%2F20201109%2F%2Fs3%2Faws4_request&X-Amz-Date=20201109T205631Z&X-Amz-Expires=432000&X-Amz-SignedHeaders=host&X-Amz-Signature=e1b8c3e4e4935cd35232407dff64d3bc3c0e65b87918f3e6c84279987e18b2e4',
            },
          ]}
        />
      )}
    </>
  );
};

DataVisualization.propTypes = {
  pipelineInView: PropTypes.string.isRequired,
  pipelineRunSelected: PropTypes.shape({
    uuid: PropTypes.string.isRequired,
    status: PropTypes.string.isRequired,
    artifacts: PropTypes.arrayOf(PropTypes.shape({
      uuid: PropTypes.string.isRequired,
      name: PropTypes.string.isRequired,
      url: PropTypes.string.isRequired,
    })).isRequired,
  }).isRequired,
  sequence: PropTypes.number.isRequired,
  setDisplayTab: PropTypes.func.isRequired,
};

export default DataVisualization;
