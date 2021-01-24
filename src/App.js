import React from 'react'
import Emoji from './Emoji'
import { apiStates, useApi } from './useApi.js'
import './App.css'

const App = () => {
  const { state, error, data, responseTime } = useApi('http://localhost:3001/api/v1/search')

  switch (state) {
    case apiStates.ERROR:
      return (
        <div className="container">
          <h3>Error: { error || 'General error' }</h3>
        </div>
      )

    case apiStates.SUCCESS:
      return (
        <div className="container">
          <h2>Most popular public GitHub repositories</h2>
          <div className="grid">
          <p>(Execution time for fetching data from API took <strong><em>{responseTime} ms</em></strong>)</p>
          {data.data.map((element) => (
            <React.Fragment key={element.name}>
              <ul className="card">
                <li><a href={element.html_url}>{element.full_name}</a></li>
                <li><em>{element.stargazers_count}</em> <Emoji symbol="⭐"/> </li>
              </ul>
            </React.Fragment>
          ))}
          </div>
        </div>
      )

    default:
      return (
        <div className="container">
          <h3>Loading..</h3>
        </div>
      )
  }
}

export default App
