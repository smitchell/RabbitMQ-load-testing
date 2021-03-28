package com.example.demo;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Component;

import java.util.concurrent.CountDownLatch;

@Component
public class Consumer {
    private final ObjectMapper mapper = new ObjectMapper();
    private final CountDownLatch latch = new CountDownLatch(1);

    public void receiveMessage(final String json) throws JsonProcessingException {
        GenericEvent event = mapper.readValue(json, GenericEvent.class);
        System.out.println("Received event id " + event.getPayload());
        latch.countDown();
    }

    public CountDownLatch getLatch() {
        return latch;
    }
}
