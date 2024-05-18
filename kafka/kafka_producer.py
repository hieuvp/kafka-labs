import json
import logging
import os
import requests
import time
import uuid

from dotenv import dotenv_values
from kafka import KafkaProducer


def get_random_user():
    response = requests.get("https://randomuser.me/api/")
    response = response.json()
    response = response["results"][0]

    return response


def format_user_data(raw_data):
    formatted_data = {
        "id": str(uuid.uuid4()),
        "first_name": raw_data["name"]["first"],
        "last_name": raw_data["name"]["last"],
        "gender": raw_data["gender"],
        "email": raw_data["email"],
        "username": raw_data["login"]["username"],
        "dob": raw_data["dob"]["date"],
        "registered_date": raw_data["registered"]["date"],
        "phone": raw_data["phone"],
        "picture": raw_data["picture"]["medium"],
    }

    location = raw_data["location"]
    formatted_data["address"] = (
        f"{str(location['street']['number'])} {location['street']['name']}, "
        f"{location['city']}, {location['state']}, {location['country']}"
    )
    formatted_data["post_code"] = location["postcode"]

    return formatted_data


def generate_data():
    bootstrap_servers = config["KAFKA_BOOTSTRAP_SERVERS"].split(",")
    producer = KafkaProducer(bootstrap_servers=bootstrap_servers, max_block_ms=5000)

    while True:

        try:
            user = get_random_user()
            user = format_user_data(user)
            user = json.dumps(user).encode("utf-8")

            producer.send("users_generated", user)
            logging.info(user)

            time.sleep(3)

        except Exception as err:
            logging.error(err)
            continue


if __name__ == "__main__":
    config = {
        **dotenv_values(".env"),
        **os.environ,
    }

    logging.basicConfig(level=config["LOG_LEVEL"])

    generate_data()
