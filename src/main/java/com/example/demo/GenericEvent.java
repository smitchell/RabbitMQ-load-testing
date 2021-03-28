package com.example.demo;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.util.Date;

@Data
@ToString
@NoArgsConstructor
public class GenericEvent {
    private String eventId;
    private String eventType;
    private String correlationId;
    private Date createDate = new Date();
    private String createdBy;
    private String payload;
}
