import { Injectable, OnModuleInit } from '@nestjs/common';
import { Client, ClientKafka } from '@nestjs/microservices';
import { config } from 'dotenv';
import { microserviceConfig } from '../microserviceConfig';
config();

@Injectable()
export class LoggerService {
  constructor() {}

  @Client(microserviceConfig)
  kafkaClient: ClientKafka;

  /**
   * This method makes a HTTP call but does not wait for the response, because it does not matter
   * @param payload T
   * @param action
   */
  createLog(payload: any, action: string): void {
    this.kafkaClient.emit('logs.create', {
      payload,
      timestamp: Number(new Date()),
      action,
    });
    return;
  }
}
