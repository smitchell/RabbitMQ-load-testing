package com.example.demo;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.commons.lang3.RandomStringUtils;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.util.UUID;
import java.util.concurrent.TimeUnit;

@Component
public class Producer implements CommandLineRunner {
    private final RabbitTemplate rabbitTemplate;
    private final Consumer consumer;

    public Producer(Consumer consumer, RabbitTemplate rabbitTemplate) {
        this.consumer = consumer;
        this.rabbitTemplate = rabbitTemplate;
    }

    @Override
    public void run(String... args) throws Exception {

        ObjectMapper mapper = new ObjectMapper();

        int i = 0;
        while (i <= 100) {
            GenericEvent event = new GenericEvent();
            event.setEventId(UUID.randomUUID().toString());
            event.setCreatedBy("smitchell");
            event.setEventType("LOAD_TEST");
            LoadTestMessage loadTestMessage = new LoadTestMessage(i, RandomStringUtils.random(25, true, false));
            event.setPayload(mapper.writeValueAsString(loadTestMessage));

            rabbitTemplate.convertAndSend(RabbitConfig.topicExchangeName, "test.message.load", mapper.writeValueAsString(event));
            consumer.getLatch().await(10000, TimeUnit.MILLISECONDS);
            i++;
        }
    }
}
