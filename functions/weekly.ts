import { Handler } from "@netlify/functions";
import axios from "axios";

const BASE_URL = "https://api.harvestapp.com/v2/reports/time/clients"

const handler: Handler = async function(event, context) {
    const {
        HARVEST_ACCESS_TOKEN: access_token,
        HARVEST_ACCOUNT_ID: account_id,
        HARVEST_PROJECT_ID: project_id,
    } = process.env;

    const params = {
        access_token,
        account_id,
        project_id,
        from: "20210101",
        to: "20211231"
    };

    const response = await axios.get( BASE_URL, { params });

    const { results } = response?.data;
    const result = results[0];
    const totalHours = result.total_hours

    return {
        statusCode: 200,
        body: JSON.stringify({totalHours})
    }
}

export { handler };
