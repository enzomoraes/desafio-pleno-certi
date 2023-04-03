import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import Mongoose, { Model } from 'mongoose';
import { CreateLogDto } from './dto/create-log.dto';
import { LogEntity } from './entities/log.entity';
import LogNotFoundException from './exceptions/LogNotFoundException';

@Injectable()
export class LogsService {
  constructor(
    @InjectModel(LogEntity.name) private readonly logModel: Model<LogEntity>,
  ) {}

  /**
   * This method creates a Log
   * @param createLogDto
   * @returns Created Log Entity
   */
  create(createLogDto: CreateLogDto): Promise<LogEntity> {
    const _id = new Mongoose.Types.ObjectId();
    const log = new this.logModel({ ...createLogDto, _id });
    return log.save();
  }

  /**
   * This method returns an array of all Logs, and has an option to change the order
   * @param orderDirection of the query
   * @returns a list of Logs
   */
  findAll(orderDirection: -1 | 1): Promise<LogEntity[]> {
    return this.logModel.find().sort({ timestamp: orderDirection });
  }

  /**
   * This method returns a log by id
   * @param id of the log
   * @returns The found Log
   */
  async findOne(id: string): Promise<LogEntity> {
    const log = await this.logModel.findById(id).exec();
    if (!log) throw new LogNotFoundException(`Could not find log of id ${id}`);
    return log;
  }
}
