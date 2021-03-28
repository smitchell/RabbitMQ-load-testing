package com.example.demo.services;

import com.example.demo.config.RabbitConfig;
import com.example.demo.models.EventMessage;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.stereotype.Service;

@Service
public class ConsumerService {
    private final ObjectMapper mapper = new ObjectMapper();

    @RabbitListener(queues = RabbitConfig.QUEUE_NAME)
    public void receiveMessage(final String json) throws JsonProcessingException {
        EventMessage event = mapper.readValue(json, EventMessage.class);
        System.out.println("Received event id " + event.getPayload());
    }
}
