import { Component, OnInit } from '@angular/core';

import { Leader } from '../shared/leader';
import { LeaderService } from '../services/leader.service';

@Component({
  selector: 'app-about',
  templateUrl: './about.component.html',
  styleUrls: ['./about.component.scss']
})
export class AboutComponent implements OnInit {
  leaders: Leader[];
  constructor(private leaderservice: LeaderService) { }

  ngOnInit() {
  	//this.leaders = this.leaderservice.getLeaders();
  	//this.leaderservice.getLeaders()
    //  .then(leaders => this.leaders = leaders);
    this.leaderservice.getLeaders()
      .subscribe(leaders => this.leaders = leaders);
  }

}
